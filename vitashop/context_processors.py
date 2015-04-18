from shop.util.cart import get_or_create_cart
from django.conf import settings
from vitashop.utils import get_currency
from vitashop.exchange import ExchangeService
from decimal import Decimal

def cart_obj(request):
    cart = get_or_create_cart(request)
    if cart:
        return dict(cart_obj=cart)
    return {}

def currency_obj(request):
    currency = get_currency(request)
    if currency:
        exs = ExchangeService(request)
        if settings.PRIMARY_CURRENCY == 'CZK':
            one_usd = exs.dollar_in_czk
        else:
            raise ValueError
        return dict(currency=currency, one_usd=one_usd)
    return {}

def currency_set(request):
    return dict(currency_set=settings.ALLOWED_CURRENCIES)


