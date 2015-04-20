#!/usr/bin/env python
import os
import sys
import logging
import requests
from decimal import Decimal
from datetime import datetime, timedelta
from django.core.mail import send_mail
from django.conf import settings
from django.utils.translation import ugettext_lazy as _
from django.template.loader import render_to_string

def send_affiliate_email(self):
    subject = 'VITAMINERAL.INFO - Affiliate Program'
    body = render_to_string('emails/affiliate_program.txt', {})
    send_mail(subject, body, settings.EMAIL_FROM, ['rjuppa@gmail.com'])


if __name__ == "__main__":
    sys.path.append('../')
    sys.path.append('.')
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "joeshop.settings")



