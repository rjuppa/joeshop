# -*- coding: utf-8 -*-
from decimal import Decimal
from django import forms
from django.conf import settings
from django.conf.urls import patterns, url
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.utils.translation import ugettext_lazy as _

from shop.util.decorators import on_method, shop_login_required, order_required

class FlatRateShippingForm(forms.Form):
    countries = forms.ChoiceField(choices=tuple([(0, '-- choose --'), (1, 'CZ'),(2, 'EU'),(3, 'nonEU')]), label=_('Shipping rate'))

class CzechRateShippingForm(forms.Form):
    countries = forms.ChoiceField(choices=tuple([(0, '-- choose --'), (1, 'Pošta EMS'),(2, 'Osobně převzít'),(3, 'PPL')]), label=_('Shipping rate'))

class EURateShippingForm(forms.Form):
    countries = forms.ChoiceField(choices=tuple([(0, '-- choose --'), (1, 'Standard Post'),(2, 'DHL Express')]), label=_('Shipping rate'))

class WorldRateShippingForm(forms.Form):
    countries = forms.ChoiceField(choices=tuple([(0, '-- choose --'), (1, 'Standard Post'),(2, 'DHL Express')]), label=_('Shipping rate'))

class FlatRateShipping(object):
    """
    This is just an example of a possible flat-rate shipping module, that
    charges a flat rate defined in settings.SHOP_SHIPPING_FLAT_RATE
    """
    url_namespace = 'flat'
    backend_name = 'Flat rate'
    backend_verbose_name = _('Flat rate')
    template = 'shop/shipping/flat_rate/display_fees.html'

    def __init__(self, shop):
        self.shop = shop  # This is the shop reference, it allows this backend
        # to interact with it in a tidy way (look ma', no imports!)
        self.rate = getattr(settings, 'SHOP_SHIPPING_FLAT_RATE', '10')

    #@on_method(shop_login_required)
    @on_method(order_required)
    def view_process_order(self, request):
        """
        A simple (not class-based) view to process an order.

        This will be called by the selection view (from the template) to do the
        actual processing of the order (the previous view displayed a summary).

        It calls shop.finished() to go to the next step in the checkout
        process.
        """
        self.shop.add_shipping_costs(self.shop.get_order(request), 'Flat shipping', Decimal(self.rate))
        return self.shop.finished(self.shop.get_order(request))
        # That's an HttpResponseRedirect

    #@on_method(shop_login_required)
    @on_method(order_required)
    def view_display_fees(self, request):
        """
        A simple, normal view that displays a template showing how much the
        shipping will be (it's an example, alright)
        """
        order = self.shop.get_order(request)
        if order.country_id == 1:
            # Czech rep.
            f = CzechRateShippingForm()
        elif order.country_id in [2, 3, 4, 5, 6]:
            # EU
            f = EURateShippingForm()
        else:
            # World
            f = WorldRateShippingForm()

        d = Decimal(self.rate)
        # f = FlatRateShippingForm()
        if request.method == 'POST':
            if u'countries' in request.POST:
                if order.country_id == 1:
                    # Czech rep.
                    f = CzechRateShippingForm(data=request.POST)
                elif order.country_id in [2, 3, 4, 5, 6]:
                    # EU
                    f = EURateShippingForm(data=request.POST)
                else:
                    # World
                    f = WorldRateShippingForm(data=request.POST)

                rate = request.POST['countries']
                d = Decimal(rate) / 100     # shipping rate is $0.02
                order = self.shop.get_order(request)
                from shop.models import ExtraOrderPriceField
                field = ExtraOrderPriceField(order=order, is_shipping=True, label='Shipping', value=d*(-1))
                field.save()


        ctx = {}
        ctx.update({'form': f})
        ctx.update({'shipping_costs': d})
        return render_to_response(self.template, ctx, context_instance=RequestContext(request))

    def get_urls(self):
        """
        Return the list of URLs defined here.
        """
        urlpatterns = patterns('',
            url(r'^$', self.view_display_fees, name='flat'),
            url(r'^process/$', self.view_process_order, name='flat_process'),
        )
        return urlpatterns
