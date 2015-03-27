from django.conf.urls import patterns, url, include
from shop.util.decorators import cart_required
from django.contrib.auth.decorators import login_required
from vitashop.views import *
from vitashop.forms import ValidatingPasswordChangeForm
from shop.views.cart import CartDetails, CartItemDetail
from django.contrib.auth.views import password_change, password_change_done
from vitashop.views_checkout import *


urlpatterns = patterns('vitashop.views',
    url(r'^$', index, name='shop_welcome'),
    url(r'^error/', error_view, name='error'),
    url(r'^test/', test_view, name='test'),
    url(r'^login/$', login_view, name='login'),
    url(r'^logout/$', logout_view, name='logout'),
    url(r'^register/$', register_view, name='register'),
    url(r'^register/success', register_success_view, name='register_success'),
    url(r'^activate/(?P<code>[0-9A-Za-z-_=.]+)$', activate_view, name='activate'),
    url(r'^profile/$', profile, name='profile'),
    url(r'^changepwd/$', password_change, {'template_name': 'vitashop/change_pwd.html',
         'password_change_form': ValidatingPasswordChangeForm}, name='password_change'),
    url(r'^changepwd/done/$', password_change_done, {'template_name': 'vitashop/change_pwd_done.html'},
                                                                name='password_change_done'),

    url(r'^setpwd/$', password_set, name='password_set'),

    url(r'^exchange/$', exchange, name='exchange'),
    url(r'^information/$', information, name='information'),
    url(r'^products/$', products, name='products'),
    url(r'^currency/$', currency, name='currency'),
    url(r'^products/(?P<slug>[0-9A-Za-z-_.//]+)/$', product_detail, name='product_detail'),

    url(r'^cart/$', MyCartDetails.as_view(), name='cart'),
    url(r'^cart/delete/$', MyCartDetails.as_view(action='delete'), name='cart_delete'),
    url(r'^cart/item/$', MyCartDetails.as_view(action='post'), name='cart_item_add'),
    url(r'^cart/update/$', MyCartDetails.as_view(action='put'), name='cart_update'),

    # CartItems
    url(r'^cart/item/(?P<id>[0-9]+)$', CartItemDetail.as_view(), name='cart_item'),
    url(r'^cart/item/(?P<id>[0-9]+)/delete$', CartItemDetail.as_view(action='delete'), name='cart_item_delete'),

    # checkout
    #url(r'^checkout/ship/flat/$', PaymentBackendRedirectView.as_view(), name='flat'),
    #url(r'^checkout/pay/pay-on-delivery/$', PaymentBackendRedirectView.as_view(), name='pay-on-delivery'),
    #url(r'^checkout/pay/advance-payment/$', PaymentBackendRedirectView.as_view(), name='advance-payment'),

    url(r'^checkout/pay/', include('shop.payment.urls')),
    url(r'^checkout/ship/', include('shop.shipping.urls')),
    url(r'^checkout/wallet', wallet, name='wallet'),

    #url(r'^checkout/ship/$', ShippingBackendRedirectView.as_view(), name='checkout_shipping'),  # second step
    #url(r'^checkout/pay/$', PaymentBackendRedirectView.as_view(), name='checkout_payment'),  # fourth step

    url(r'^checkout/$', login_required(cart_required(MyCheckoutSelectionView.as_view())), name='checkout_selection'),  # first step
    url(r'^methods/$', login_required(cart_required(CheckoutMethodsView.as_view())), name='checkout_methods'),
    url(r'^overview/$', login_required(cart_required(OverviewView.as_view())), name='checkout_overview'),
    url(r'^checkout/thank_you/$', ThankYouView.as_view(), name='checkout_thankyou'),  # final step

    url(r'^checkout/ppsuccess', pp_success_page, name='ppsuccess'),
    url(r'^checkout/ppcanceled', pp_canceled_page, name='ppcanceled'),
    url(r'^checkout/ppfailed', pp_failed_page, name='ppfailed'),

    url(r'^orders/(?P<pk>\d+)/$', OrderDetailView.as_view(), name='order_detail'),

)
