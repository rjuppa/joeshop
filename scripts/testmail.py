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
    subject = 'VITAMINERAL.INFO - Affiliate Program'
    body = render_to_string('../templates/mails/affiliate_program.html', {})
    try:
        msg = EmailMessage(subject, body, 'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM, ['rjuppa@gmail.com'])
        msg.content_subtype = "html"
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