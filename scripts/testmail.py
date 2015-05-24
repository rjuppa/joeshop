#!/usr/bin/env python
import os
import sys
import django
from django.core.mail import send_mail
from django.conf import settings
from django.utils.translation import ugettext_lazy as _
from django.template.loader import render_to_string
from django.core.mail import EmailMultiAlternatives, EmailMessage

def send_affiliate_email():
    subject = 'VITAMINERAL.INFO - payment received'
    text_content = render_to_string('../templates/mails/payment_received.txt', {})
    html_content = render_to_string('../templates/mails/payment_received.html', {})
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
    django.setup()

    send_affiliate_email()

    print "Sent."