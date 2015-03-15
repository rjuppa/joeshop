from decimal import Decimal
from django.conf import settings

class ExchangeService(object):

    dollar_in_usd = Decimal('1')
    dollar_in_czk = Decimal('25.10')
    dollar_in_btc = Decimal('0.00010')

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


    def convert_to_dec(self, price):
        f = round(price, 2)
        s = str(f) + '0000000000'
        n = s.index('.')
        return Decimal(s[0:n+2])
    # Decimal(str(round(price, 2)) + '0')