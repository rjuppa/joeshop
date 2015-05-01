from django.conf import settings
from bip32utils import BIP32Key
import requests
import logging

logger = logging.getLogger('vitashop.checkout')

def get_currency(request):
    if 'currency' in request.session:
        return request.session['currency']
    else:
        return settings.PRIMARY_CURRENCY

def get_language(request):
    if hasattr(request, 'LANGUAGE_CODE'):
        return request.LANGUAGE_CODE
    else:
        return 'en'

def track_it(func):
    """
    decorator for tracking / logging code use: @track_it
    """
    def inner(*args, **kwargs):
        logger.debug('func %s started' % func.func_name)
        ret = func(*args, **kwargs)
        logger.debug('func #%s# ended' % func.func_name)
        return ret
    return inner

class Blockchain(object):

    SATOSHI = 100000000
    api_uri = 'https://insight.bitpay.com/api'
    #
    # {"addrStr": "1DYCkkJePht4T3hpB68DBktv7AB97GnrwY",
    #  "balance": 0.00109326,
    #  "balanceSat": 109326,
    #  "totalReceived": 0.00109326,
    #  "totalReceivedSat": 109326,
    #  "totalSent": 0,
    #  "totalSentSat": 0,
    #  "unconfirmedBalance": 0,
    #  "unconfirmedBalanceSat": 0,
    #  "unconfirmedTxApperances": 0,
    #  "txApperances": 1,
    #  "transactions": ["2806ec1144e3613d11756841648a7af39fe9405d3457a72af2df767979412a59"]}

    @classmethod
    def get_address_info(cls, addr):
        r = requests.get('%s/addr/%s' % (cls.api_uri, addr))
        return r.json()

class Address(object):

    def __init__(self):
        self.desc = ''
        self.address = ''
        self.balance = 0
        self.unconfirmed_balance = 0


class Account(object):

    def __init__(self, xpub):
        self.addresses = []
        self.transactions = []
        self.mask = 'm/1/0/'
        self.account = BIP32Key.fromExtendedKey(xpub)
        self.ext_node = self.account.ChildKey(0)

    def gen_new_address(self, order_id):
        addr_node = self.ext_node.ChildKey(order_id)
        address = addr_node.Address()
        return address

    def check_order_for_payment(self, order):
        confirmed = 0
        try:
            addr = self.check_address_for_payment(order.wallet_address)
            confirmed = addr.balance / Blockchain.SATOSHI
        except Exception as ex:
            logger.error(ex)

        if confirmed >= order.price:
            return True
        else:
            return False


    def check_address_for_payment(self, address):
        j = Blockchain.get_address_info(address)
        a = Address()
        a.address = str(j['addrStr'])
        a.balance = int(j['totalReceivedSat'])
        a.unconfirmed_balance = int(j['unconfirmedBalanceSat'])
        return a
