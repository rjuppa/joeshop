#!/usr/bin/env python
import os
import sys
import logging
import requests
import django
from decimal import Decimal
from datetime import datetime, timedelta
from django.utils import timezone, translation
from django.conf import settings


logger = logging.getLogger('scripts')

# def cleanup_cancelled(cls):
#     old = cls.objects.filter(transaction_status=cls.CANCELLED, order_status=cls.CANCELLED,
#                              created__lte=timezone.now() - timedelta(days=7))
#     for o in old:
#         print "Deleting order", o
#         o.delete()

def get_received_by_address(address, confirm):
    btc = 0
    # Get the total number of bitcoins received by an address (in satoshi).
    url = "http://blockchain.info/q/getreceivedbyaddress/%s?confirmations=%s" % (address, confirm)
    r = requests.get(url)
    if r.status_code == 200:
        btc = Decimal(r.text) / 10 ** 8
    else:
        # blockchain.info can be busy: Maximum concurrent requests reached. Please try again shortly
        pass

    return btc

def check_orders_for_unconfirmed_payments():
    # take newly placed orders - CONFIRMED orders
    # choose bitcoin and PaymentHistory.UNCONFIRMED
    # and verify if payment was received
    logger = logging.getLogger('shop')
    orders = Order.objects.filter(status=Order.CONFIRMED).order_by('created')[:100]
    for order in orders:
        ph = PaymentHistory.get_by_order(order)
        if ph and ph.payment_method == 'bitcoin' \
                and (ph.status == PaymentHistory.CREATED or ph.status == PaymentHistory.UNCONFIRMED):

            # check bitcoins received
            unconfirmed_btc = get_received_by_address(ph.wallet_address, 0)

            # set language
            language = 'cs'     # default
            user = MyUser.objects.get(id=order.user_id)
            if user:
                language = user.lang

            # UNCONFIRMED - enough money
            if unconfirmed_btc >= (ph.order_price - settings.BTC_PRICE_TOLERANCE):
                logger.debug("UNCONFIRMED balance of %s (order %s) is %s BTC" % (ph.wallet_address, order.id, unconfirmed_btc))

                if ph.status == PaymentHistory.CREATED:
                    # send email only one time
                    ph.send_unconfirmed_payment_email(unconfirmed_btc)  # SEND EMAIL

                    # update PaymentHistory
                    ph.status = PaymentHistory.UNCONFIRMED
                    ph.save()

            # CANCELLED
            elif ph.created <= (timezone.now() - timedelta(hours=6)):
                # Mark timed out transactions as cancelled
                logger.debug("Setting order %s as CANCELLED" % (order.id))
                # update PaymentHistory
                ph.status = PaymentHistory.CANCELLED
                ph.save()

                # update Order
                order.status = Order.CANCELLED
                order.save()

            translation.deactivate()


def check_orders_for_payment_confirmation():
    # take newly placed orders - CONFIRMED orders
    # choose bitcoin and PaymentHistory.UNCONFIRMED
    # and verify if payment was confirmed
    logger = logging.getLogger('shop')

    # placed orders
    orders = Order.objects.filter(status=Order.CONFIRMED).order_by('created')[:100]
    for order in orders:
        ph = PaymentHistory.get_by_order(order)
        if ph and ph.payment_method == 'bitcoin' \
                and (ph.status == PaymentHistory.CREATED or ph.status == PaymentHistory.UNCONFIRMED):

            # set language
            language = 'cs'     # default
            user = MyUser.objects.get(id=order.user_id)
            if user:
                language = user.lang

            translation.activate(language)

            # check bitcoins received
            confirmed_btc = get_received_by_address(ph.wallet_address, 3)

            # PAID (CONFIRMED) - enough money
            if confirmed_btc >= (ph.order_price - settings.BTC_PRICE_TOLERANCE):
                logger.debug("Order %s is PAID" % order.id)

                # update PaymentHistory
                ph.amount = confirmed_btc
                ph.status = PaymentHistory.CONFIRMED
                ph.save()

                # update Order
                order.status = Order.COMPLETED
                order.save()
                ph.send_money_received_email(confirmed_btc)  # SEND EMAIL

            # Received NOT ENOUGH MONEY
            elif (confirmed_btc > 0) and (confirmed_btc < (ph.order_price - settings.BTC_PRICE_TOLERANCE)):

                if ph.amount < confirmed_btc:   # only once
                    logger.debug("Order %s received insufficient payment!!" % order.id)
                    ph.send_insufficient_payment_email(confirmed_btc)  # SEND EMAIL

                    # update PaymentHistory
                    ph.amount = confirmed_btc
                    ph.status = PaymentHistory.UNCONFIRMED
                    ph.save()

            translation.deactivate()



if __name__ == "__main__":
    sys.path.append('../')
    sys.path.append('.')
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "joeshop.settings")
    django.setup()

    from django.db import connection
    from shop.models import Order
    from vitashop.models import PaymentHistory, MyUser

    check_orders_for_payment_confirmation()
    check_orders_for_unconfirmed_payments()

    connection.close()
