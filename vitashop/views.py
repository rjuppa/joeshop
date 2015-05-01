from django.shortcuts import render
from django.conf import settings
from django.http import HttpResponse, HttpResponseBadRequest, HttpResponseRedirect, request
from django.core.urlresolvers import reverse
from django.core.exceptions import ValidationError
from django.contrib.auth import authenticate, login
from django.contrib.auth import logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import PasswordChangeForm
from django.contrib.sites.models import get_current_site
from django.contrib import messages
from django.template import RequestContext
from django.shortcuts import render_to_response, redirect
from django.template import Context, loader
from decimal import Decimal
from shop.views.cart import CartDetails, CartItemDetail
from shop.models.defaults.order import Order
from vitashop.models import *
from vitashop.forms import *
from shop.util.btc_helper import Coindesk_Exchange, BC, CNB_Exchange
from django.utils.decorators import method_decorator
from django.utils.translation import ugettext as _
from shop.views import ShopListView, ShopDetailView
from shop.forms import get_cart_item_formset
from shop.models.productmodel import Product
from shop.util.cart import get_or_create_cart
from shop.views import ShopView, ShopTemplateResponseMixin
from vitashop.utils import get_currency, get_language
from vitashop.views_checkout import add_order_to_context


def index(request):
    ctx = {}
    logger.debug('load view: index')
    return render(request, 'vitashop/index.html', ctx)


def test_view(request):
    ctx = RequestContext(request, {})
    return render(request, 'vitashop/test.html', ctx)


def error_view(request):
    ctx = {}
    logger.debug('load view: error_view')
    return render(request, 'vitashop/error.html', ctx)




def products(request):
    logger.debug('load view: products')
    products = MyProduct.objects.filter(active=True).order_by('ordering')
    ctx = {'products': products}
    return render(request, 'vitashop/products.html', ctx)


def product_detail(request, slug):
    logger.debug('load view: product_detail')
    if not slug:
        return HttpResponseRedirect(reverse('products'))

    try:
        product = MyProduct.objects.get(slug=slug)
    except:
        product = None

    products = MyProduct.objects.filter(active=True).order_by('name')
    ctx = {'products': products, 'product': product}
    ctx['desc2'] = _(product.desc2)
    return render(request,  'vitashop/product_detail.html', ctx)


def oauth2callback(request):
    pass


def currency(request):
    user = request.user
    next = ''
    slug = None
    currency = 'CZK'
    ctx = dict(site=get_current_site(request))
    if request.method == 'POST':
        if 'sel_currency' in request.POST:
            currency = request.POST['sel_currency']
            request.session['currency'] = currency
        if 'next' in request.POST:
            next, slug = clean_next(request.POST['next'])

    if next:
        if slug:
            url = reverse(next, kwargs={'slug': slug})
        else:
            url = reverse(next)
    else:
        url = reverse('products')   # fallback
    return HttpResponseRedirect(url)


def clean_next(value):
    if not value:
        return None, None
    li = value.split(' ', 2)
    if len(li) > 1:
        return li[0], li[1]
    else:
        return li[0], None


def activate_view(request, code):
    logger.debug('load view: activate_view')
    ctx = {}
    if MyUser.objects.activate(code):
        messages.success(request, 'Your account has been activated successfully.')
        return HttpResponseRedirect(reverse('profile'))
    else:
        messages.error(request, 'Your activation code was not found. (Maybe expired)', extra_tags='danger')
        return render(request, 'vitashop/error.html', ctx)


@login_required
def profile(request):
    # show user profile page
    logger.debug('load view: profile')
    user = request.user
    customer = None
    try:
        customer = Customer.objects.get_by_email(user.email)
        if not customer and Customer.objects.has_user_paid_order(user):
            # create customer
            currency = get_currency(request)
            language = get_language(request)
            customer = Customer.objects.create(user, language, currency)
    except Exception as ex:
        logger.error(ex)

    ctx = dict(site=get_current_site(request))
    if request.method == 'POST':
        profile_form = ProfileForm(request.POST, instance=user)
        if profile_form.is_valid():
            profile_form.save()
            messages.success(request, 'Your profile has updated.')
        else:
            messages.error(request, 'Unable to save changes.', extra_tags='danger')

    else:
        profile_form = ProfileForm(instance=user)

    orders = Order.objects.filter(user=user).order_by('-created')
    ctx['orders'] = orders
    ctx['customer'] = customer
    ctx['profile_form'] = profile_form
    ctx['use_password'] = user.has_usable_password()
    return render(request, 'vitashop/profile.html', ctx)


@login_required
def password_set(request):
    logger.debug('load view: password_set')
    if request.user.has_usable_password():
        return HttpResponseRedirect(reverse('profile'))

    # user has not usable_password set
    ctx = dict(site=get_current_site(request))
    if request.method == 'POST':
        form = SetPasswordForm(request.POST)
        if form.is_valid():
            request.user.set_password(form.clean_new_password1())
            request.user.save()
            return HttpResponseRedirect(reverse('profile'))

        # form contains data and errors
        ctx['form'] = form
    else:
        ctx['form'] = SetPasswordForm()
    return render(request, 'vitashop/set_pwd.html', ctx)



def login_view(request):
    logger.debug('load view: login_view')
    user = request.user
    ctx = dict(site=get_current_site(request))
    ctx['message'] = ''
    ctx['SOCIAL_AUTH_FACEBOOK_KEY'] = settings.SOCIAL_AUTH_FACEBOOK_KEY
    ctx['SOCIAL_AUTH_GOOGLE_PLUS_KEY'] = settings. SOCIAL_AUTH_GOOGLE_PLUS_KEY

    # default next
    next = reverse('profile')

    # POST
    if request.method == 'POST':
        form = AuthenticationForm(request.POST)
        ctx['form'] = form
        username = request.POST['username']
        password = request.POST['password']
        if 'next' in request.POST:
            next = request.POST['next']

        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_active:
                login(request, user)
                # Redirect to a success page.
                return HttpResponseRedirect(next)
            else:
                form.add_error("username", 'Account is not active. Check your mailbox for activation email.')
        else:
            form.add_error("password", 'invalid login')
        ctx['next'] = next
        return render(request, 'vitashop/login.html', ctx)

    # GET
    ctx['form'] = AuthenticationForm
    if 'next' in request.GET:
        next = request.GET['next']
    ctx['next'] = next
    return render(request, 'vitashop/login.html', ctx)

def logout_view(request):
    logger.debug('load view: logout_view')
    logout(request)
    return HttpResponseRedirect(reverse('shop_welcome'))

def register_success_view(request):
    logger.debug('load view: register_success_view')
    email = ''
    if 'email' in request.GET:
        email = request.GET['email']
    ctx = dict(site=get_current_site(request))
    ctx['email'] = email
    return render(request, 'vitashop/register_success.html', ctx)

def register_view(request):
    logger.debug('load view: register_view')
    ctx = dict(site=get_current_site(request))
    ctx['message'] = ''
    ctx['SOCIAL_AUTH_FACEBOOK_KEY'] = settings.SOCIAL_AUTH_FACEBOOK_KEY
    ctx['SOCIAL_AUTH_GOOGLE_PLUS_KEY'] = settings. SOCIAL_AUTH_GOOGLE_PLUS_KEY
    if request.method == 'POST':
        form = RegistrationForm(request.POST)
        ctx['form'] = form
        if form.is_valid():
            user = form.save()
            user.send_registration_mail()
            return HttpResponseRedirect(reverse('register_success') + '?email=' + user.email)

        return render(request, 'vitashop/register.html', ctx)
    # GET
    ctx['form'] = RegistrationForm
    return render(request, 'vitashop/register.html', ctx)

@login_required
def change_pwd(request):
    logger.debug('load view: change_pwd')
    user = request.user
    ctx = dict(site=get_current_site(request))
    if request.method == 'POST':
        pwd_form = PasswordChangeForm(request.POST, instance=user)
        if pwd_form.is_valid():
            pwd_form.save()
            messages.success(request, 'Saved successfully.')
        else:
            messages.success(request, 'Error...')

    else:
        pwd_form = PasswordChangeForm(instance=user)

    ctx['pwd_form'] = pwd_form
    return render(request, 'vitashop/change_pwd.html', ctx)



class OrderDetailView(ShopDetailView):
    """
    Display order for logged in user.
    """
    template_name = 'vitashop/order_detail.html'
    queryset = Order.objects.all()

    def get_queryset(self):
        queryset = super(OrderDetailView, self).get_queryset()
        queryset = queryset.filter(user=self.request.user)
        return queryset

    def get_context_data(self, **kwargs):
        ctx = super(OrderDetailView, self).get_context_data(**kwargs)
        if self.object:
            ctx = add_order_to_context(ctx, self.object)
        return ctx

    @method_decorator(login_required)
    def dispatch(self, *args, **kwargs):
        logger.debug('load view: OrderDetailView.dispatch')
        return super(OrderDetailView, self).dispatch(*args, **kwargs)

    def get(self, request, *args, **kwargs):
        order_id = self.kwargs.get('id')
        try:
            self.object = Order.objects.get(id=order_id)
        except Order.DoesNotExist:
            self.object = None
            return HttpResponseBadRequest("Order not found")

        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)

class MyCartDetails(ShopTemplateResponseMixin, CartItemDetail):
    """
    This is the actual "cart" view, that answers to GET and POST requests like
    a normal view (and returns HTML that people can actually see)
    """

    template_name = 'vitashop/cart.html'
    action = None

    def get_context_data(self, **kwargs):
        # There is no get_context_data on super(), we inherit from the mixin!
        logger.debug('load view: MyCartDetails.get_context_data')
        ctx = {}
        cart = get_or_create_cart(self.request)
        cart.update(self.request)
        ctx.update({'cart': cart})
        ctx.update({'cart_items': cart.get_updated_cart_items()})
        return ctx

    def get(self, request, *args, **kwargs):
        """
        This is lifted from the TemplateView - we don't get this behavior since
        this only extends the mixin and not templateview.
        """
        context = self.get_context_data(**kwargs)
        formset = get_cart_item_formset(cart_items=context['cart_items'])
        context.update({'formset': formset, })
        return self.render_to_response(context)

    def post(self, *args, **kwargs):
        """
        This is to *add* a new item to the cart. Optionally, you can pass it a
        quantity parameter to specify how many you wish to add at once
        (defaults to 1)
        """
        try:
            product_id = int(self.request.POST['add_item_id'])
            product_quantity = int(self.request.POST.get('add_item_quantity', 1))
        except (KeyError, ValueError):
            return HttpResponseBadRequest("The quantity and ID have to be numbers")
        product = Product.objects.get(pk=product_id)
        cart_object = get_or_create_cart(self.request, save=True)
        cart_item = cart_object.add_product(product, product_quantity)
        cart_object.save()
        return self.post_success(product, cart_item)

    def delete(self, *args, **kwargs):
        """
        Empty shopping cart.
        """
        cart_object = get_or_create_cart(self.request)
        cart_object.empty()
        return self.delete_success()

    def put(self, *args, **kwargs):
        """
        Update shopping cart items quantities.

        Data should be in update_item_ID=QTY form, where ID is id of cart item
        and QTY is quantity to set.
        """
        context = self.get_context_data(**kwargs)
        try:
            formset = get_cart_item_formset(cart_items=context['cart_items'],
                    data=self.request.POST)
        except ValidationError:
            return redirect('cart')
        if formset.is_valid():
            formset.save()
            return self.put_success()
        context.update({'formset': formset, })
        return self.render_to_response(context)


def exchange(request):
    exs = Coindesk_Exchange(request)
    ctx = {}
    ctx['updated'] = exs.updated_formated()
    ctx['btc_dollar'] = exs.get_btc_in_dollar()
    ctx['btc_euro'] = exs.get_btc_in_euro()

    cnb = CNB_Exchange(request)
    ctx['cnb_updated'] = cnb.updated_formated()
    ctx['usd_in_czk'] = cnb.get_dollar_in_czk()
    ctx['eur_in_czk'] = cnb.get_euro_in_czk()
    return render(request, 'vitashop/exchange.html', ctx)


def wallet(request):
    addr = request.GET['addr']
    amount = request.GET['amount']
    b = BC()
    # addr = 'mnaJBGpyB1JHxD43UQsU2GhaRauKNfDWTc'
    # amount = Decimal('0.02000')
    b.pay_to_address(addr, Decimal(amount))

    ctx = {}
    ctx['addr'] = addr
    ctx['amount'] = amount
    return render(request, 'vitashop/wallet.html', ctx)



# error pages
def error400(request):
    ctx = {}
    ctx['message'] = 'Bad request. (status=400)'
    response = render_to_response('vitashop/error.html', ctx, context_instance=RequestContext(request))
    response.status_code = 400
    return response

def error403(request):
    ctx = {}
    ctx['message'] = 'Permission denied. (status=403)'
    response = render_to_response('vitashop/error.html', ctx, context_instance=RequestContext(request))
    response.status_code = 403
    return response

def error404(request):
    ctx = {}
    ctx['message'] = 'Page not found. (status=404)'
    response = render_to_response('vitashop/error.html', ctx, context_instance=RequestContext(request))
    response.status_code = 404
    return response

def error500(request):
    ctx = {}
    ctx['message'] = 'Server error. (status=500)'
    response = render_to_response('vitashop/error.html', ctx, context_instance=RequestContext(request))
    response.status_code = 500
    return response
