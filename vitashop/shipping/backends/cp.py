# -*- coding: utf-8 -*-
from decimal import Decimal
from django import forms
from django.conf import settings
from django.conf.urls import patterns, url
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.utils.translation import ugettext_lazy as _
from shop.models import ExtraOrderPriceField
from shop.util.decorators import on_method, shop_login_required, order_required

class CPostaShippingForm(forms.Form):
    locations = forms.ChoiceField(choices=tuple([(0, '-- choose --'),
                                                 (1, 'Praha'),
                                                 (2, 'Plzen'),
                                                 (3, 'Brno'),
                                                 (4, 'Ostrava')]), label=_('Location to pick up'))

class CPostaShipping(object):
    """
    This is just an example of a possible flat-rate shipping module, that
    charges a flat rate defined in settings.SHOP_SHIPPING_FLAT_RATE
    """
    url_namespace = 'cposta'
    backend_name = 'CPosta shipping'
    backend_verbose_name = 'Česká Pošta'
    template = 'vitashop/shipping/cp/posta.html'

    def __init__(self, shop):
        self.shop = shop
        self.rate = '0.5'   # it is free

    @property
    def cost(self):
        return Decimal(self.rate)

    #@on_method(shop_login_required)
    @on_method(order_required)
    def view_process_order(self, request):
        """
        This will be called by the selection view (from the template) to do the
        actual processing of the order (the previous view displayed a summary).
        It calls shop.finished() to go to the next step in the checkout
        process.
        """
        self.shop.add_shipping_costs(self.shop.get_order(request), 'CPosta shipping', Decimal(self.rate))
        return self.shop.finished(self.shop.get_order(request))
        # That's an HttpResponseRedirect

    #@on_method(shop_login_required)
    @on_method(order_required)
    def view_display_fees(self, request):
        """
        A simple, normal view that displays a template showing how much the
        shipping will be (it's an example, alright)
        """

        form = CPostaShippingForm()    # Czech rep.
        d = Decimal(self.rate)
        if request.method == 'POST':
            if u'locations' in request.POST:
                # Czech rep.
                form = CPostaShippingForm(data=request.POST)
                order = self.shop.get_order(request)
                field = ExtraOrderPriceField(order=order, is_shipping=True, label='Shipping', value=d*(-1))
                field.save()

        ctx = {}
        ctx.update({'form': form})
        ctx.update({'shipping_costs': d})
        return render_to_response(self.template, ctx, context_instance=RequestContext(request))

    def get_urls(self):
        """
        Return the list of URLs defined here.
        """
        urlpatterns = patterns('',
            url(r'^$', self.view_display_fees, name='cposta'),
            url(r'^process/$', self.view_process_order, name='cposta_process'),
        )
        return urlpatterns

