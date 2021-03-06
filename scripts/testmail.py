#!/usr/bin/env python
import os
import sys
import django
from django.conf import settings
from django.utils.translation import ugettext_lazy as _
from django.utils import timezone, translation
from django.template.loader import render_to_string
from django.core.mail import EmailMultiAlternatives


def send_affiliate_email():
    order = Order()
    order.id = 99

    translation.activate('cs')
    subject = 'VITAMINERAL.INFO - payment received'
    text_content = render_to_string('vitashop/mails/payment_received.txt', {'amount': 2.3, 'order': order, 'currency': 'XY'})
    html_content = render_to_string('vitashop/mails/payment_received.html', {'amount': 2.3, 'order': order, 'currency': 'XY'})
    try:
        msg = EmailMultiAlternatives(subject, text_content,
                                     'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                     ['rjuppa@gmail.com'])
        msg.attach_alternative(html_content, "text/html")
        msg.send()
    except Exception as ex:
        print ex

if __name__ == "__main__":
    sys.path.append('../')
    sys.path.append('.')
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "joeshop.settings")
    from vitashop.models import Order
    django.setup()


    send_affiliate_email()

    print "Sent."