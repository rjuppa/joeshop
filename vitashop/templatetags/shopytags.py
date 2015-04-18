# -*- coding: utf-8 -*-
from django import template

from classytags.helpers import InclusionTag
from classytags.core import Options
from classytags.arguments import Argument
from django.template.defaultfilters import floatformat
from decimal import Decimal
from shop.util.cart import get_or_create_cart
from shop.models.productmodel import Product
from vitashop.utils import get_currency
from django.conf import settings


register = template.Library()

class Cart(InclusionTag):
    """
    Inclusion tag for displaying cart summary.
    """
    template = 'vitashop/templatetags/_cart.html'

    def convert_koruna_into(self, amount, currency, one_usd=1):
        if currency == 'CZK':
            price = amount
            return price
        elif currency == 'USD':
            price = amount / one_usd
            return price
        else:
            raise KeyError

    def get_price_formated(self, price, currency, one_usd):
        if settings.PRIMARY_CURRENCY == 'CZK':
            if currency == settings.PRIMARY_CURRENCY:
                return str(price) + ' ' + currency
            elif currency == 'USD':
                usd_price = self.convert_koruna_into(price, currency, one_usd)
                f = floatformat(usd_price, 2)
                usd_price = Decimal(str(f).replace(',', '.'))
                return str(usd_price) + ' ' + currency


    def get_context(self, context, **kwargs):
        request = context['request']
        cart = get_or_create_cart(request)
        cart.currency = get_currency(request)
        cart.update(request)
        cart.total_price_in_currency = self.get_price_formated(cart.total_price, cart.currency, context['one_usd'])
        return {'cart': cart}
register.tag(Cart)


class Order(InclusionTag):
    """
    Inclusion tag for displaying order.
    """
    template = 'vitashop/templatetags/_order.html'
    options = Options(
        Argument('order', resolve=True),
        )

    def get_context(self, context, order):
        return {
            'order': order
        }
register.tag(Order)


class Products(InclusionTag):
    """
    Inclusion tag for displaying all products.
    """
    template = 'vitashop/templatetags/_products.html'
    options = Options(
        Argument('objects', resolve=True, required=False),
    )

    def get_context(self, context, objects):
        if objects is None:
            objects = Product.objects.filter(active=True)
        context.update({'products': objects, })
        return context
register.tag(Products)

def priceformat(price):
    FORMAT = getattr(settings, 'SHOP_PRICE_FORMAT', '%0.2f')
    if not price and price != 0:
        return ''
    return FORMAT % price
register.filter(priceformat)


