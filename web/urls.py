from django.conf.urls import patterns, url, include
from shop.util.decorators import cart_required
from django.contrib.auth.decorators import login_required
from vitashop.views import *
from vitashop.forms import ValidatingPasswordChangeForm
from shop.views.cart import CartDetails, CartItemDetail
from django.contrib.auth.views import password_change, password_change_done
from web.views import *


urlpatterns = patterns('web.views',
    url(r'^contact/', contact_view, name='contact'),
    url(r'^information/', information_view, name='information'),
    url(r'^bitcoins/', bitcoin_view, name='bitcoin'),
    url(r'^faq/', faq_view, name='faq'),
    url(r'^affiliate/', affiliate_view, name='affiliate'),
    url(r'^thankyou/', thankyou_view, name='thankyou'),
    url(r'^fbtest/', fbtest_view, name='fbtest'),
)
