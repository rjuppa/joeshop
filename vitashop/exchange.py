from decimal import Decimal
from django.conf import settings
from django.template.defaultfilters import floatformat
from shop.util.btc_helper import Coindesk_Exchange, BC, CNB_Exchange

class ExchangeService(object):

    def __init__(self, request):
        btc = Coindesk_Exchange(request)
        cnb = CNB_Exchange(request)
        self.btc_in_dollar = btc.get_btc_in_dollar()
        self.dollar_in_usd = Decimal('1')
        self.dollar_in_czk = cnb.get_dollar_in_czk()
        self.dollar_in_btc = Decimal('1') / self.btc_in_dollar


        self.koruna_in_usd = Decimal('1')/self.dollar_in_czk
        self.koruna_in_czk = Decimal('1')
        self.koruna_in_btc = Decimal('1') / (btc.get_btc_in_dollar()*self.dollar_in_czk)

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
        if settings.PRIMARY_CURRENCY == 'CZK':
            new_value = self.convert_koruna_into(amount, 'USD')
        else:
            raise ValueError
        s = floatformat(new_value, 2)
        s = s.replace(',', '.')
        return Decimal(str(s))

    def one_btc_in_czk(self):
        if settings.PRIMARY_CURRENCY == 'CZK':
            new_value = self.btc_in_dollar * self.dollar_in_czk
        else:
            raise ValueError
        s = floatformat(new_value, 2)
        s = s.replace(',', '.')
        return Decimal(str(s))

    def convert_to_dec(self, price):
        f = round(price, 2)
        s = str(f) + '0000000000'
        n = s.index('.')
        return Decimal(s[0:n+2])
    # Decimal(str(round(price, 2)) + '0')