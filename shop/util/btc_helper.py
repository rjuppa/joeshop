import json
import pickle
import urllib2
from decimal import Decimal
from datetime import datetime

from django.conf import settings

from shop.util.bip32 import get_address_for_account
import bitcoin
import bitcoin.rpc

class Exchange(object):
    DATE_FORMAT = "%Y-%m-%d %H:%M"
    SESSION_NAME = 'exchange_rate'
    COIN = 1000000
    FEE = Decimal(1)/10000
    content = {}
    _req = None

    def __init__(self, req):
        if not req:
            raise ValueError('req is None')

        self._req = req
        if 'exchange_rate' in req.session:
            self.load(req)

        if not self.content:
            self.refresh()


    def load(self, req):
        if not req:
            raise ValueError('req is None')

        self._req = req
        if 'exchange_rate' in req.session:
            data = req.session[self.SESSION_NAME]
            self.content = pickle.loads(data.encode('utf-8'))
        else:
            self.content = {}

    def refresh(self):
        # refresh btc rate
        try:
            response = urllib2.urlopen('http://api.coindesk.com/v1/bpi/currentprice.json')
            html = response.read()
            jdata = json.loads(html)

            self.content = {}
            self.content.update({'btc_in_dollar': jdata["bpi"]["USD"]["rate_float"]})
            self.content.update({'btc_in_euro': jdata["bpi"]["EUR"]["rate_float"]})
            self.content.update({'updated': datetime.now().strftime(self.DATE_FORMAT)})

            # save to session
            self._req.session[self.SESSION_NAME] = pickle.dumps(self.content).decode('utf-8')
        except Exception as e:
            s = e.args[0]
            pass

    def is_up_to_date(self):
        # rate is up-to-date 15 minutes
        if not self.updated:
            return False
        d = datetime.now() - self.updated()
        if d.seconds < 900: # 15min = 900 sec.
            return True
        else:
            return False

    def updated(self):
        if 'updated' in self.content:
            date = self.content['updated']
            return datetime.strptime(date, self.DATE_FORMAT)
        else:
            return False

    def get_btc_in_dollar(self):
        if not self.is_up_to_date():
            self.refresh()
        rate = Decimal(self.content['btc_in_dollar'])
        return Decimal(round(rate * self.COIN)) / self.COIN

    def get_btc_in_euro(self):
        if not self.is_up_to_date():
            self.refresh()
        rate = Decimal(self.content['btc_in_euro'])
        return Decimal(round(rate * self.COIN)) / self.COIN

    def convert_dollar_to_btc(self, dollar):
        if not self.is_up_to_date():
            self.refresh()
        dolar_rate = self.get_btc_in_dollar()
        btc = round(dollar / dolar_rate * self.COIN)
        return Decimal(btc)/self.COIN + self.FEE

    def convert_euro_to_btc(self, euro):
        if not self.is_up_to_date():
            self.refresh()
        euro_rate = self.get_btc_in_euro()
        btc = round(euro / euro_rate * self.COIN)
        return Decimal(btc)/self.COIN + self.FEE

    @classmethod
    def format_btc(cls, dec):
        return "%s BTC" % dec

    @classmethod
    def format_milibtc(cls, dec):
        return "%s mBTC" % dec * 1000

    @classmethod
    def format_microbtc(cls, dec):
        return "%s &micro;BTC" % dec * 1000000


class BC(object):
    COIN = 10**8
    _rpc = None

    def __init__(self):
        bitcoin.SelectParams('testnet')
        self._rpc = bitcoin.rpc.Proxy()

    def create_wallet_address(self, order_id):
        if order_id < 0:
            raise Exception("order_id cannot be negative!")

        return get_address_for_account(settings.XPUB, order_id, settings.ADDRESS_TYPE)

    def check_order_for_payment(self, order):
        confirmed = 0
        try:
            confirmed = self._rpc.getreceivedbyaddress(order.wallet_address)

            # response = urllib2.urlopen('http://blockchain.info/q/getreceivedbyaddress/" + order.wallet_address + "?confirmations=3')
            # html = response.read()
            # confirmed = Decimal(html) / 10 ** 8
        except Exception as ex:
            s = ex.args

        if confirmed >= order.price:
            return True
        else:
            return False

    def pay_to_address(self, addr, amount):
        txid = self._rpc.sendtoaddress(addr, amount * self.COIN)
        pass


