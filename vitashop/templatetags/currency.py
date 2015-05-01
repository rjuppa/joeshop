from django import template
from django.template.defaultfilters import floatformat
from decimal import Decimal
from django.conf import settings
from vitashop.exchange import ExchangeService
from vitashop.utils import get_currency

register = template.Library()

@register.filter(name='currency')
def currency(value, currency):
    """Removes all values of arg from the given string"""

    # exs = ExchangeService()
    # if settings.PRIMARY_CURRENCY == 'USD':
    #     new_value = exs.convert_dollar_into(value, currency)
    # elif settings.PRIMARY_CURRENCY == 'CZK':
    #     new_value = exs.convert_koruna_into(value, currency)
    # else:
    #     raise ValueError
    new_value = 1
    s = floatformat(new_value, 2)
    return s + ' ' + currency


@register.simple_tag(takes_context=True)
def currency_tag(context, value, currency):
    if not value:
        value = 0
    if settings.PRIMARY_CURRENCY == 'CZK':
        if currency == settings.PRIMARY_CURRENCY:
            return str(value) + ' ' + currency
        elif currency == 'USD':
            usd_price = convert_koruna_into(value, currency, context['one_usd'])
            f = floatformat(usd_price, 2)
            usd_price = Decimal(str(f).replace(',', '.'))
            return str(usd_price) + ' ' + currency
    raise KeyError


def convert_koruna_into(amount, currency, one_usd=1):
    if currency == 'CZK':
        price = amount
        return price
    elif currency == 'USD':
        price = amount / one_usd
        return price
    else:
        raise KeyError