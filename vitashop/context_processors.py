from shop.util.cart import get_or_create_cart
from django.conf import settings
from vitashop.utils import get_currency

def cart_obj(request):
    cart = get_or_create_cart(request)
    if cart:
        return dict(cart_obj=cart)
    return {}

def currency_obj(request):
    currency = get_currency(request)
    if currency:
        return dict(currency=currency)
    return {}

def currency_set(request):
    return dict(currency_set=settings.ALLOWED_CURRENCIES)


