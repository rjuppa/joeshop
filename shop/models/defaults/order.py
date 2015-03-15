# -*- coding: utf-8 -*-
from django.utils.translation import ugettext_lazy as _
from shop.models_bases import BaseOrder
from shop.models_bases.managers import OrderManager
from django.utils.translation import ugettext_lazy as _
from django.db import models
from shop.util.fields import CurrencyField

class Order(BaseOrder):
    objects = OrderManager()

    class Meta(object):
        abstract = False
        app_label = 'shop'
        verbose_name = _('Order')
        verbose_name_plural = _('Orders')


