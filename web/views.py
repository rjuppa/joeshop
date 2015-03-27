from django.shortcuts import render
from django.conf import settings
from django.http import HttpResponse, HttpResponseBadRequest, HttpResponseRedirect, request
from django.core.urlresolvers import reverse
from django.contrib.sites.models import get_current_site
from django.contrib import messages
from django.template import RequestContext
from django.shortcuts import render_to_response, redirect
from django.template import Context, loader
from web.forms import ContactForm
from django.core.mail import send_mail


def information_view(request):
    ctx = {}
    return render(request, 'web/information.html', ctx)

def faq_view(request):
    ctx = {}
    return render(request, 'web/faq.html', ctx)


def bitcoin_view(request):
    ctx = {}
    return render(request, 'web/bitcoin.html', ctx)


def affiliate_view(request):
    ctx = {'message': ''}
    return render(request, 'web/affiliate.html', ctx)


def thankyou_view(request):
    ctx = {'message': ''}
    return render(request, 'web/thankyou.html', ctx)


def contact_view(request):
    ctx = {'message': ''}
    is_error = False
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            body = form.cleaned_data['comment'] + '\n'
            body += '------------------------------------------------\n\n'
            body += 'Name: %s\n' % form.cleaned_data['name']
            body += 'Email: %s\n' % form.cleaned_data['email']
            body += 'Subject: %s\n' % form.cleaned_data['subject']
            body += 'Comment:\n %s\n' % form.cleaned_data['comment']

            subject = form.cleaned_data['subject']
            send_mail(subject, body, form.cleaned_data['email'], [settings.EMAIL_ADMIN])
            url = reverse('thankyou')
            return HttpResponseRedirect(url)

        # show errors in html
        is_error = True
        if form.errors:
            for name in form.errors:
                err_item = form.errors[name]
                message = err_item[0].replace('This field', name)
                messages.error(request, message, extra_tags='danger')
    else:
        form = ContactForm()

    ctx['form'] = form
    ctx['is_error'] = is_error
    return render(request, 'web/contact.html', ctx)




