# -*- coding: utf-8 -*-
from decimal import Decimal
from datetime import date
from django.conf.urls import patterns, url
from django.template import RequestContext
from django.utils.translation import ugettext_lazy as _
from django.shortcuts import render_to_response
from django.core.exceptions import ObjectDoesNotExist
from shop.models.ordermodel import Order, OrderPayment
from shop.models.cartmodel import Cart
from shop.util.decorators import on_method, order_required
from shop.util.btc_helper import Coindesk_Exchange
from shop.order_signals import confirmed
from shop.util.bip32 import get_address_for_account
from django.conf import settings
import urllib

class BitcoinBackend(object):
    url_namespace = 'bitcoin-payment'
    backend_name = _('Bitcoin payment')
    template = 'vitashop/payment/bitcoin.html'

    def __init__(self, shop):
        self.shop = shop

    def get_urls(self):
        urlpatterns = patterns('',
            url(r'^$', self.bitcoin_payment_view, name='bitcoin-payment'),
        )
        return urlpatterns

    @on_method(order_required)
    def bitcoin_payment_view(self, request):
        """
        This view displays a note onto which bitcoun address the customer shall
        send the requested amount. It then confirms the order by adding
        zero money as the received payment for that order.
        """
        order = self.shop.get_order(request)
        ex = Coindesk_Exchange(request)
        amount_dollar = self.shop.get_order_total(order)
        amount_btc = ex.convert_dollar_to_btc(amount_dollar)
        transaction_id = date.today().strftime('%Y') + '%06d' % order.id
        wallet_address = self._create_confirmed_order(order, transaction_id)
        chl = urllib.quote("bitcoin:%s?amount=%s" % (wallet_address, amount_btc))
        context = RequestContext(request, {'order': order, 'amount_dollar': amount_dollar,
                                           'amount_btc': amount_btc,
                                        'wallet_address': wallet_address,
                                        'qrcode': 'https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=%s' % chl,
                                        'transaction_id': transaction_id, 'next_url': self.shop.get_finished_url()})
        return render_to_response(self.template, context)

    def _create_confirmed_order(self, order, transaction_id):
        """
        Create an order from the current cart but does not mark it as payed.
        Instead mark the order as CONFIRMED only, as somebody manually has to
        check if bitcoins were received (or auto script) and mark the payments.
        """
        wallet_address = self.create_wallet_address(order.id)
        try:
            op = OrderPayment.objects.get(wallet_address=wallet_address)
            return wallet_address
        except OrderPayment.DoesNotExist:
            # create OrderPayment once
            OrderPayment.objects.create(order=order, amount=Decimal(0),
                                        status=OrderPayment.CREATED,
                                        wallet_address=wallet_address,
                                        transaction_id=transaction_id,
                                        payment_method=self.backend_name)

            # Confirm the current order
            order.status = Order.CONFIRMED
            order.save()



        # empty the related cart
        try:
            cart = Cart.objects.get(pk=order.cart_pk)
            cart.empty()
        except Cart.DoesNotExist:
            pass
        confirmed.send(sender=self, order=order)
        return wallet_address

    def create_wallet_address(self, id):
        if id < 0:
            raise Exception("id cannot be negative!")

        return get_address_for_account(settings.XPUB, id, settings.ADDRESS_TYPE)