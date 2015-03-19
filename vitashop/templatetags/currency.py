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
    # d = Decimal(value)
    exs = ExchangeService()
    #cur = get_currency()
    if settings.PRIMARY_CURRENCY == 'USD':
        new_value = exs.convert_dollar_into(value, currency)
    elif settings.PRIMARY_CURRENCY == 'CZK':
        new_value = exs.convert_koruna_into(value, currency)
    else:
        raise ValueError
    s = floatformat(new_value, 2)
    return s + ' ' + currency



