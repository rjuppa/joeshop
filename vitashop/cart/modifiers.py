#-*- coding: utf-8 -*-
from decimal import Decimal
from shop.cart.cart_modifiers_base import BaseCartModifier
from django.utils.translation import ugettext_lazy as _
from vitashop.models import Customer

class AffiliateModifier(BaseCartModifier):

    def get_extra_cart_price_field(self, cart, request):
        """
        Add a rebate to a line item depending on the quantity ordered:
        """
        REBATE_PERCENTAGE = Decimal('5')
        result_tuple = None
        if request.user and not request.user.is_anonymous:
            cust = Customer.objects.get_by_email(request.user.email)
            if cust:
                rebate = (REBATE_PERCENTAGE / 100) * cart.current_total
                rabate = round(-rebate, 2)
                result_tuple = (_('Member discount'), Decimal(str(rabate)))
                return result_tuple  # Returning None is ok
        return None