# -*- coding: utf-8 -*-
import logging
import requests
from decimal import Decimal
from datetime import date
from urlparse import urlparse, parse_qs, unquote
from django.conf.urls import patterns, url
from django.template import RequestContext
from django.utils.translation import ugettext_lazy as _
from django.shortcuts import render_to_response
from django.core.exceptions import ObjectDoesNotExist
from shop.models.ordermodel import Order
from shop.models.cartmodel import Cart
from shop.util.decorators import on_method, order_required
from shop.order_signals import completed, confirmed
from vitashop.models import PaymentHistory
from django.conf import settings


logger = logging.getLogger('vitashop')


class PaypalBackend(object):
    url_namespace = 'paypal'
    backend_name = _('Paypal payment')
    template = 'vitashop/payment/paypal.html'

    def __init__(self, shop):
        self.shop = shop

    def get_urls(self):
        urlpatterns = patterns('',
            url(r'^$', self.paypal_payment_view, name='paypal'),
            url(r'^success$', self.paypal_success_view, name='paypal-success'),
            url(r'^failed', self.paypal_failed_view, name='paypal-failed'),
        )
        return urlpatterns

    @on_method(order_required)
    def paypal_payment_view(self, request):
        """
        This view displays a note onto which bitcoun address the customer shall
        send the requested amount. It then confirms the order by adding
        zero money as the received payment for that order.
        """
        order = self.shop.get_order(request)
        amount_dollar = self.shop.get_order_total(order)
        context = RequestContext(request, {'order': order, 'amount_dollar': amount_dollar,
                                         'next_url': self.shop.get_finished_url()})
        return render_to_response(self.template, context)

    def paypal_success_view(self, request):
        pass

    def paypal_failed_view(self, request):
        pass


class PaypalAPI(object):

    @classmethod
    def get_order(cls, order_id):
        try:
            return Order.objects.get(id=order_id)
        except Order.DoesNotExist:
            return None

    @classmethod
    def place_payment(cls, order, currency, price, user, coupon='', method='paypal'):
        # log payment
        if not user:
            raise ValueError('user')
        if not order:
            raise ValueError('order')

        ph = PaymentHistory()
        ph.order = order
        ph.email = user.email
        ph.amount = Decimal(price)
        ph.currency = currency
        ph.payment_method = method
        ph.result = 'place_order'
        ph.status = PaymentHistory.CREATED
        ph.transaction_id = ''
        ph.save()
        return ph.id

    @classmethod
    def confirm_payment(cls, order, transaction_id, result):
        if not order:
            raise ValueError('order')

        ph = PaymentHistory.get_by_order(order)
        if ph:
            ph.payment_id = transaction_id
            ph.result = result
            ph.save(update_fields=['result', 'transaction_id'])

            if order.is_paid():
                # Set the order status:
                order.status = Order.COMPLETED
                order.save()

                # empty the related cart
                try:
                    cart = Cart.objects.get(pk=order.cart_pk)
                    cart.empty()
                except Cart.DoesNotExist:
                    pass

                completed.send(sender=None, order=order)
                return True
            else:
                return False

        else:
            logger.error('PaymentHistory for order=%s not found.' % order.id)

    @classmethod
    def call_express_checkout(cls, order, currency, sprice, user, coupon='', lang='en'):
        # create pre-order in DB
        if not order:
            raise ValueError('order')
        if not user:
            raise ValueError('user')

        PaypalAPI.place_payment(order, currency, sprice, user, coupon, 'paypal')
        if order.id > 0:
            site = 'http://daily4sport.com:8000/'
            url = 'http://daily4sport.com:8000/vitashop/'
            ppsuccess = '%scheckout/ppsuccess/' % url
            ppcanceled = '%scheckout/ppcanceled/' % url
            param = (settings.PAYPAL_USERNAME, settings.PAYPAL_PASSWORD, settings.PAYPAL_SIGNATURE, settings.PAYPAL_VERSION, order.id, sprice, currency, site, lang, ppsuccess, ppcanceled)
            payload = 'USER=%s&PWD=%s&SIGNATURE=%s&METHOD=SetExpressCheckout&VERSION=%s&PAYMENTREQUEST_0_PAYMENTACTION=SALE&PAYMENTREQUEST_0_CUSTOM=%s&PAYMENTREQUEST_0_AMT=%s&PAYMENTREQUEST_0_CURRENCYCODE=%s&PAGESTYLE=joeshop&LOGOIMG=%s/img/logo_90x60.png&CARTBORDERCOLOR=A0CF29&NOSHIPPING=1&LOCALECODE=%s&RETURNURL=%s&CANCELURL=%s' % param

            # Set Express order in Paypal
            r = requests.post(settings.PAYPAL_SIG_URL, data=payload)
            logger.debug('call_express_checkout: r.status_code == %s ' % r.status_code)
            if r.status_code == 200:
                data = parse_qs(r.text)
                tt = data['TOKEN'][0]
                ack = data['ACK'][0]
                logger.debug('call_express_checkout ack: %s ' % ack)
                token = unquote(tt)
                return settings.PAYPAL_REDIRECT % token  # return token
            else:
                r.raise_for_status()
        else:
            raise ValueError('order_id')

    @classmethod
    def do_express_checkout_payment(cls, payer_id, token, sprice, currency='USD'):
        param = (settings.PAYPAL_USERNAME, settings.PAYPAL_PASSWORD, settings.PAYPAL_SIGNATURE, settings.PAYPAL_VERSION, token, payer_id, sprice, currency)
        payload = 'USER=%s&PWD=%s&SIGNATURE=%s&METHOD=DoExpressCheckoutPayment&VERSION=%s&TOKEN=%s&PAYERID=%s&PAYMENTREQUEST_0_PAYMENTACTION=SALE&PAYMENTREQUEST_0_AMT=%s&PAYMENTREQUEST_0_CURRENCYCODE=%s' % param
        r = requests.post(settings.PAYPAL_SIG_URL, data=payload)
        logger.debug('do_express_checkout_payment: r.status_code == %s ' % r.status_code)
        if r.status_code == 200:
            data = parse_qs(r.text)
            ack = data['ACK'][0]
            logger.debug('do_express_checkout_payment ack: %s ' % ack)
            if ack.lower() == 'success':
                return True
            else:
                msg = data['L_LONGMESSAGE0'][0]
                logger.debug('do_express_checkout_payment L_LONGMESSAGE0: %s ' % msg)
                return False
        else:
            r.raise_for_status()

    @classmethod
    def get_express_checkout_details(cls, token):
        param = (settings.PAYPAL_USERNAME, settings.PAYPAL_PASSWORD, settings.PAYPAL_SIGNATURE, settings.PAYPAL_VERSION, token)
        payload = 'USER=%s&PWD=%s&SIGNATURE=%s&METHOD=GetExpressCheckoutDetails&VERSION=%s&TOKEN=%s' % param
        r = requests.post(settings.PAYPAL_SIG_URL, data=payload)
        logger.debug('get_express_checkout_details: r.status_code == %s ' % r.status_code)
        if r.status_code == 200:
            data = parse_qs(r.text)
            ack = data['ACK'][0]
            logger.debug('get_express_checkout_details ack: %s ' % ack)
            custom = data['CUSTOM'][0]
            return custom
        else:
            r.raise_for_status()
