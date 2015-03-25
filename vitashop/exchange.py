from decimal import Decimal
from django.conf import settings
from django.template.defaultfilters import floatformat

class ExchangeService(object):

    dollar_in_usd = Decimal('1')
    dollar_in_czk = Decimal('25.10')
    dollar_in_btc = Decimal('0.00010')

    koruna_in_usd = Decimal('1')/Decimal('25.10')
    koruna_in_czk = Decimal('1')
    koruna_in_btc = Decimal('0.000007')

    def convert_dollar_into(self, amount, currency):
        if currency == 'CZK':
            price = amount * self.dollar_in_czk
            return price
        elif currency == 'USD':
            price = amount * self.dollar_in_usd
            return price
        elif currency == 'BTC':
            price = amount * self.dollar_in_btc
            return price
        else:
            raise KeyError

    def convert_koruna_into(self, amount, currency):
        if currency == 'CZK':
            price = amount * self.koruna_in_czk
            return price
        elif currency == 'USD':
            price = amount * self.koruna_in_usd
            return price
        elif currency == 'BTC':
            price = amount * self.koruna_in_btc
            return price
        else:
            raise KeyError

    def price_in_usd(self, amount):
        exs = ExchangeService()
        if settings.PRIMARY_CURRENCY == 'USD':
            new_value = exs.convert_dollar_into(amount, 'USD')
        elif settings.PRIMARY_CURRENCY == 'CZK':
            new_value = exs.convert_koruna_into(amount, 'USD')
        else:
            raise ValueError
        s = floatformat(new_value, 2)
        return Decimal(str(s))

    def convert_to_dec(self, price):
        f = round(price, 2)
        s = str(f) + '0000000000'
        n = s.index('.')
        return Decimal(s[0:n+2])
    # Decimal(str(round(price, 2)) + '0')