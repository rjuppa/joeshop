from shop.cart.cart_modifiers_base import BaseCartModifier
from decimal import Decimal # We need this because python's float are confusing

class MyModifier(BaseCartModifier):
    """
    An example class that will grant a 10% discount to shoppers who buy
    more than 10 worth of goods.
    """
    def get_extra_cart_price_field(self, cart, request):
        pass
        ten_percent = Decimal('10') / Decimal('100')
        # Now we need the current cart total. It's not just the subtotal field
        # because there may be other modifiers before this one
        total = cart.current_total

        if total > Decimal('10'):
            rebate_amount = total * ten_percent
            rebate_amount = - rebate_amount # a rebate is a negative difference
            extra_dict = { 'Rebate': '%s %%' % ten_percent }
            return ('My awesome rebate', rebate_amount)
        else:
            return None # None is no-op: it means "do nothing"

    def get_extra_cart_item_price_field(self, cart, request):
        pass
        # # Do modifications per cart item here
        # label = 'a label'  # to distinguish, which modifier changed the price
        # extra_price = Decimal(0)  # calculate addition cost here, can be a negative value
        # extra_dict = {}  # an optional Python dictionary serializable as JSON
        #                  # which can be used to store arbitrary data
        # return (label, extra_price, extra_dict)

    def post_process_cart(self, cart, request):
        total = cart.current_total



