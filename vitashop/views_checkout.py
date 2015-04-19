# -*- coding: utf-8 -*-
"""
This models the checkout process using views.
"""
import json
import logging
import urllib
import datetime
from pytz import timezone
from decimal import Decimal
from django.core.urlresolvers import reverse
from django.forms import models as model_forms
from django.http import HttpResponseRedirect
from vitashop.shipping.backends.cp import CPostaShipping
from shop.models import AddressModel, OrderExtraInfo
from shop.models import Order
from shop.util.address import (
    assign_address_to_request,
    get_billing_address_from_request,
    get_shipping_address_from_request,
)
from vitashop.shop_api import VitashopAPI
from shop.util.cart import get_or_create_cart
from shop.util.order import add_order_to_request, get_order_from_request
from shop.views import ShopTemplateView, ShopView
from shop.util.login_mixin import LoginMixin
from vitashop.forms import ShippingForm, BillingForm
from vitashop.payment.backends.paypal import *
from vitashop.utils import get_currency
from vitashop.exchange import ExchangeService
from shop.backends_pool import backends_pool
from shop.util.btc_helper import Coindesk_Exchange
from vitashop.utils import Account

logger = logging.getLogger('vitashop.checkout')

class MyCheckoutSelectionView(LoginMixin, ShopTemplateView):
    template_name = 'vitashop/checkout/selection.html'
    use_billing = True

    def _get_dynamic_form_class_from_factory(self):
        """
        Returns a dynamic ModelForm from the loaded AddressModel
        """
        form_class = model_forms.modelform_factory(
            AddressModel, exclude=['user_shipping', 'user_billing'])
        return form_class

    def get_shipping_form_class(self):
        """
        Provided for extensibility.
        """
        return self._get_dynamic_form_class_from_factory()

    def get_billing_form_class(self):
        """
        Provided for extensibility.
        """
        return self._get_dynamic_form_class_from_factory()

    def create_order_object_from_cart(self):
        """
        This will create an Order object form the current cart, and will pass
        a reference to the Order on either the User object or the session.
        """
        cart = get_or_create_cart(self.request)
        cart.update(self.request)
        order = Order.objects.create_from_cart(cart, self.request)
        request = self.request
        add_order_to_request(request, order)
        return order

    def get_shipping_address_form(self):
        """
        Initializes and handles the form for the shipping address.

        AddressModel is a model of the type defined in
        ``settings.SHOP_ADDRESS_MODEL``.

        The trick here is that we generate a ModelForm for whatever model was
        passed to us by the SHOP_ADDRESS_MODEL setting, and us this, prefixed,
        as the shipping address form. So this can be as complex or as simple as
        one wants.

        Subclasses of this view can obviously override this method and return
        any other form instead.
        """
        # Try to get the cached version first.
        form = getattr(self, '_shipping_form', None)
        if not form:
            # Create a dynamic Form class for the model specified as the
            # address model
            form_class = self.get_shipping_form_class()

            # Try to get a shipping address instance from the request (user or
            # session))
            shipping_address = get_shipping_address_from_request(self.request)
            if self.request.method == "POST":
                form = form_class(self.request.POST, prefix="ship",
                    instance=shipping_address)
            else:
                # We should either have an instance, or None
                if not shipping_address:
                    # The user or guest doesn't already have a favorite
                    # address. Instanciate a blank one, and use this as the
                    # default value for the form.
                    shipping_address = AddressModel()

                # Instanciate the form
                form = form_class(instance=shipping_address, prefix="ship")
            setattr(self, '_shipping_form', form)
        return form

    def get_billing_address_form(self):
        """
        Initializes and handles the form for the shipping address.
        AddressModel is a model of the type defined in
        ``settings.SHOP_ADDRESS_MODEL``.
        """
        # Try to get the cached version first.
        form = getattr(self, '_billing_form', None)
        if not form:
            # Create a dynamic Form class for the model specified as the
            # address model
            form_class = self.get_billing_form_class()

            # Try to get a shipping address instance from the request (user or
            # session))
            billing_address = get_billing_address_from_request(self.request)
            if self.request.method == "POST":
                form = form_class(self.request.POST, prefix="bill",
                    instance=billing_address)
            else:
                # We should either have an instance, or None
                if not billing_address:
                    # The user or guest doesn't already have a favorite
                    # address. Instansiate a blank one, and use this as the
                    # default value for the form.
                    billing_address = AddressModel()

                #Instanciate the form
                form = form_class(instance=billing_address, prefix="bill")
            setattr(self, '_billing_form', form)
        return form

    def get_empty_billing_address(self):
        form_class = self.get_billing_form_class()
        billing_address = AddressModel()
        return form_class(instance=billing_address, prefix="bill")

    def address_toJSON(self, addr):
        d = {}
        d['name'] = addr.name
        d['address'] = addr.address
        d['address2'] = addr.address2
        d['city'] = addr.city
        d['state'] = addr.state
        d['zip_code'] = addr.zip_code
        d['country'] = addr.country.name
        return json.dumps(d)

    def save_addresses_to_order(self, order, shipping_address, billing_address):
        """
        Provided for extensibility.

        Adds both addresses (shipping and billing addresses) to the Order
        object.
        """
        order.shipping_address_text = self.address_toJSON(shipping_address)
        order.billing_address_text = self.address_toJSON(billing_address)
        order.country = shipping_address.country
        order.save()

    def post(self, *args, **kwargs):
        """ Called when view is POSTed """
        self.use_billing = False
        if 'use_billing' in self.request.POST:
            self.use_billing = True

        if self.use_billing:
            # use both addr (shipping and billing)
            shipping_form = self.get_shipping_address_form()
            billing_form = self.get_billing_address_form()
            if shipping_form.is_valid() and billing_form.is_valid():
                # Add the address to the order
                shipping_address = shipping_form.save()
                billing_address = billing_form.save()
                order = self.create_order_object_from_cart()
                self.save_addresses_to_order(order, shipping_address, billing_address)
                assign_address_to_request(self.request, shipping_address, shipping=True)
                assign_address_to_request(self.request, billing_address, shipping=False)
                return HttpResponseRedirect(reverse('checkout_methods'))
        else:
            # only shipping addr (billing is same)
            shipping_form = self.get_shipping_address_form()
            if shipping_form.is_valid():
                shipping_address = shipping_form.save()
                order = self.create_order_object_from_cart()
                self.save_addresses_to_order(order, shipping_address, shipping_address)
                assign_address_to_request(self.request, shipping_address, shipping=True)
                assign_address_to_request(self.request, shipping_address, shipping=False)
                return HttpResponseRedirect(reverse('checkout_methods'))

        return self.get(self, *args, **kwargs)


    def get_context_data(self, **kwargs):
        """
        This overrides the context from the normal template view
        """
        ctx = super(MyCheckoutSelectionView, self).get_context_data(**kwargs)
        shipping_address_form = self.get_shipping_address_form()
        if self.use_billing:
            billing_address_form = self.get_billing_address_form()
        else:
            billing_address_form = self.get_empty_billing_address()

        ctx.update({
            'shipping_address': shipping_address_form,
            'billing_address': billing_address_form,
        })
        return ctx


class CheckoutMethodsView(LoginMixin, ShopTemplateView):
    template_name = 'vitashop/checkout/methods.html'
    api = None

    def get_shipping_selection_form(self):
        """
        Get (and cache) the BillingShippingForm instance
        """
        form = getattr(self, '_shipping_form', None)
        if not form:
            if self.request.method == 'POST':
                form = ShippingForm(self.request.POST)
            else:
                form = ShippingForm()
            self._shipping_form = form
        return form

    def get_billing_selection_form(self):
        """
        Get (and cache) the BillingShippingForm instance
        """
        form = getattr(self, '_billing_form', None)
        if not form:
            if self.request.method == 'POST':
                form = BillingForm(self.request.POST)
            else:
                form = BillingForm()
            self._billing_form = form
        return form

    def get_context_data(self, **kwargs):
        ctx = super(CheckoutMethodsView, self).get_context_data(**kwargs)
        shipping_form = self.get_shipping_selection_form()
        billing_form = self.get_billing_selection_form()
        shipping_price = Decimal(CPostaShipping.rate)
        ctx.update({
            'shipping_form': shipping_form,
            'billing_form': billing_form,
            'shipping_price': shipping_price
        })

        return ctx

    def add_shipping_cost(self, order, backend_url):
        cost = 0
        shipping_backends = backends_pool.get_shipping_backends_list()
        for backend in shipping_backends:
            if backend.url_namespace == backend_url:
                cost = backend.cost

        self.api.add_shipping_costs(order=order, label='Shipping', value=cost)

    def dispatch(self, request, *args, **kwargs):
        self.api = VitashopAPI()
        return super(CheckoutMethodsView, self).dispatch(request, *args, **kwargs)

    def post(self, *args, **kwargs):
        """ Called when view is POSTed """
        shipping_form = self.get_shipping_selection_form()
        billing_form = self.get_billing_selection_form()
        if shipping_form.is_valid() and billing_form.is_valid():
            # save selected billing and shipping methods
            self.request.session['payment_backend'] = billing_form.cleaned_data['payment_method']
            self.request.session['shipping_backend'] = shipping_form.cleaned_data['shipping_method']

            order = get_order_from_request(self.request)
            self.add_shipping_cost(order, shipping_form.cleaned_data['shipping_method'])
            return self.api.finished(order)

        return self.get(self, *args, **kwargs)


class OverviewView(LoginMixin, ShopTemplateView):
    template_name = 'vitashop/checkout/overview.html'
    order = None
    payment = None
    shipping = None

    def get_extra_info_form(self):
        """
        Initializes and handles the form for order extra info.
        """
        # Try to get the cached version first.
        form = getattr(self, '_extra_info_form', None)
        if not form:
            # Create a dynamic Form class for the model
            form_class = model_forms.modelform_factory(OrderExtraInfo, exclude=['order'])
            if self.request.method == 'POST':
                form = form_class(self.request.POST)
            else:
                form = form_class()
            setattr(self, '_extra_info_form', form)
        return form

    def save_extra_info_to_order(self, order, form):
        if form.cleaned_data.get('text'):
            extra_info = form.save(commit=False)
            extra_info.order = order
            extra_info.save()

    def create_wallet_address(self, id):
        if id < 0:
            raise Exception("id cannot be negative!")

        if settings.DEBUG:
            return "BTC-ADDRESS-MISSING-IN-DEBUG"
        acc = Account(settings.XPUB)
        return acc.gen_new_address(id)

    def create_confirmed_order(self, order):
        """
        Create an order from the current cart but does not mark it as payed.
        Instead mark the order as CONFIRMED only, as somebody manually has to
        check if bitcoins were received (or auto script) and mark the payments.
        """
        wallet_address = self.create_wallet_address(order.id)
        try:
            ph = PaymentHistory.objects.get(wallet_address=wallet_address)
            return wallet_address
        except PaymentHistory.DoesNotExist:
            # create OrderPayment once
            PaymentHistory.objects.create(order=order, amount=Decimal(0),
                                        email=self.request.user.email,
                                        currency='BTC',
                                        status=PaymentHistory.CREATED,
                                        wallet_address=wallet_address,
                                        transaction_id='',
                                        result = 'placed_order',
                                        payment_method='bitcoin')

            # Confirm the current order
            order.status = Order.CONFIRMED
            order.save()

        # empty the related cart
        try:
            cart = Cart.objects.get(pk=order.cart_pk)
            cart.empty()
        except Cart.DoesNotExist:
            pass
        confirmed.send(sender=self, order=order)
        return wallet_address

    def get_context_data(self, **kwargs):
        ctx = super(OverviewView, self).get_context_data(**kwargs)
        extra_info_form = self.get_extra_info_form()
        ctx.update({'extra_info_form': extra_info_form})
        self.order = get_order_from_request(self.request)
        ctx.update({'order': self.order})

        shipping_address = json.loads(self.order.shipping_address_text)
        ctx.update({'shipping_address_name': shipping_address['name']})
        ctx.update({'shipping_address_street': shipping_address['address'] + ' ' + shipping_address['address2']})
        ctx.update({'shipping_address_city': shipping_address['city']})
        ctx.update({'shipping_address_state': shipping_address['state']})
        ctx.update({'shipping_address_zip': shipping_address['zip_code']})
        ctx.update({'shipping_address_country': shipping_address['country']})
        billing_address = json.loads(self.order.billing_address_text)
        ctx.update({'billing_address_name': billing_address['name']})
        ctx.update({'billing_address_street': billing_address['address'] + ' ' + billing_address['address2']})
        ctx.update({'billing_address_city': billing_address['city']})
        ctx.update({'billing_address_state': billing_address['state']})
        ctx.update({'billing_address_zip': billing_address['zip_code']})
        ctx.update({'billing_address_country': billing_address['country']})
        if shipping_address['name'] == billing_address['name'] \
            and shipping_address['address'] == billing_address['address'] \
            and shipping_address['address2'] == billing_address['address2'] \
            and shipping_address['city'] == billing_address['city'] \
            and shipping_address['state'] == billing_address['state'] \
            and shipping_address['zip_code'] == billing_address['zip_code'] \
            and shipping_address['country'] == billing_address['country']:
            ctx.update({'is_billing_address_same': True})
        else:
            ctx.update({'is_billing_address_same': False})

        self.payment = self.request.session['payment_backend']
        self.shipping = self.request.session['shipping_backend']
        ctx.update({'shipping_backend': self.shipping})
        ctx.update({'payment_backend': self.payment})
        return ctx

    def post(self, *args, **kwargs):
        """ Called when view is POSTed """
        order = get_order_from_request(self.request)
        self.create_confirmed_order(order)
        return HttpResponseRedirect(reverse('checkout_thankyou'))


class ThankYouView(LoginMixin, ShopTemplateView):
    template_name = 'vitashop/checkout/thank_you.html'
    url_name = 'checkout_thankyou'
    order = None
    payment = None
    shipping = None

    def get_context_data(self, **kwargs):
        ctx = super(ThankYouView, self).get_context_data(**kwargs)

        # put the latest order in the context only if it is completed
        order = get_order_from_request(self.request)
        if order and order.status == Order.CONFIRMED:
            ctx.update({'order': order, })

        self.payment = self.request.session['payment_backend']
        self.shipping = self.request.session['shipping_backend']
        ctx.update({'shipping_backend': self.shipping})
        ctx.update({'payment_backend': self.payment})
        my_date = datetime.datetime.now(timezone(settings.TIME_ZONE))
        ctx.update({'now':my_date})

        if self.payment == 'paypal':
            pass
        elif self.payment == 'bitcoin-payment':
            # convert price in dollar into BTC
            exs = ExchangeService(self.request)
            price_usd = exs.price_in_usd(order.order_total)     # order price is in CZK
            ex = Coindesk_Exchange(self.request)
            amount_fiat = order.order_total
            ctx.update({'amount_fiat': amount_fiat})
            amount_btc = ex.convert_dollar_to_btc(price_usd)
            ctx.update({'amount_btc': amount_btc})
            transaction_id = date.today().strftime('%Y') + '%06d' % order.id
            ctx.update({'transaction_id': transaction_id})
            ph = PaymentHistory.get_by_order(order)
            ctx.update({'wallet_address': ph.wallet_address})
            rate_btc = exs.one_btc_in_czk()
            ctx.update({'rate_btc': rate_btc})
            chl = urllib.quote("bitcoin:%s?amount=%s" % (ph.wallet_address, amount_btc))
            ctx.update({'qrcode': 'https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=%s' % chl})
        else:
            raise ValueError
        return ctx


    def post(self, *args, **kwargs):
        # need to pay on Paypal in USD
        order = get_order_from_request(self.request)
        sprice = str(order.order_total)
        try:
            #urllib.quote_plus(sprice)
            url = PaypalAPI.call_express_checkout(order, 'USD', sprice, self.request.user, '')
        except Exception as ex:
            logger.error(ex)
            return HttpResponseRedirect(reverse('error'))

        return HttpResponseRedirect(url)



def pp_canceled_page(request):
    logger.info('pp_canceled_page..')
    context = RequestContext(request, {})
    if request.method == 'GET':
        token = ''
        if 'token' in request.GET.keys():
            token = request.GET['token']
        detail = ''
        if token:
            try:
                detail = PaypalAPI.get_express_checkout_details(token)
            except:
                pass

            logger.info("pp_canceled_page - detail='%s' " % detail)
            if detail:
                order_id = int(detail)
                if order_id > 0:
                    order = PaypalAPI.get_order(order_id)
                    if order:
                        PaypalAPI.confirm_payment(order, '', 'canceled')
                    else:
                        logger.error("order not found detail='%s' " % detail)

    context['error'] = 'payment was canceled by user'
    return render_to_response('vitashop/checkout/ppcanceled.html', context)

def pp_failed_page(request):
    logger.info('pp_failed_page..')
    if request.method == 'GET':
        context = RequestContext(request, {})
        token = ''
        if 'token' in request.GET.keys():
            token = request.GET['token']

        detail = ''
        if token:
            try:
                detail = PaypalAPI.get_express_checkout_details(token)
            except:
                pass

            logger.info("pp_failed_page - detail='%s' " % detail)
            if detail:
                order_id = int(detail)
                if order_id > 0:
                    order = PaypalAPI.get_order(order_id)
                    if order:
                        PaypalAPI.confirm_payment(order, '', 'failed')
                    else:
                        logger.error("order not found detail='%s' " % detail)

        context['error'] = 'payment failed'
        return render_to_response('vitashop/checkout/ppfailed.html', context)

def pp_success_page(request):
    """
    handle call from success Paypal
    read express checkout details from Paypal
    find OrderPayment for the order
    do express checkout payment
    save OrderPayment
    confirm payment
    and render success or error page
    """
    logger.debug('pp_success_page')
    if request.user.is_authenticated():
        context = RequestContext(request, {})
        if request.method == 'GET':
            payer_id = ''
            if 'PayerID' in request.GET.keys():
                payer_id = request.GET['PayerID']

            token = ''
            if 'token' in request.GET.keys():
                token = request.GET['token']

            detail = ''
            if token:
                try:
                    detail = PaypalAPI.get_express_checkout_details(token)
                except Exception as ex:
                    logger.error(ex)

            logger.debug('pp_success_page - detail=%s ' % detail)
            if detail:
                order_id = int(detail)
                if order_id > 0:
                    order = PaypalAPI.get_order(order_id)
                    if order:
                        ph = PaymentHistory.get_by_order(order_id)
                        if ph:
                            sprice = str(ph.amount)

                            # PAY
                            result = PaypalAPI.do_express_checkout_payment(payer_id, token, sprice)
                            if result:
                                if PaypalAPI.confirm_payment(order, payer_id, 'success'):
                                    context['order'] = order
                                    return render_to_response('vitashop/checkout/ppsuccess.html', context)
                                else:
                                    context['error'] = 'You pay less then is the prize. Order total price is $%s' % sprice
                                return render_to_response('vitashop/checkout/ppfailed.html', context)
                            else:
                                PaypalAPI.confirm_payment(order, payer_id, 'failed')
                                context['error'] = 'An error has occurred in payment processing.'
                                return render_to_response('vitashop/checkout/ppfailed.html', context)
                        else:
                            logger.error('OrderPayment for order=%s not found.' % order_id)

            msg = 'order_not_found'
            context['error'] = msg
            logger.info("order_not_found: '%s' " % detail)
            return render_to_response('vitashop/checkout/ppfailed.html', context)
        else:
            # this should not happen
            return render_to_response('vitashop/checkout/ppsuccess.html', context)
    else:
        context = {}
        context['play_url'] = settings.LANGEVO_PLAY
        context['error'] = 'NOT_AUTHENTICATED'
        return render_to_response('vitashop/error.html', context)


