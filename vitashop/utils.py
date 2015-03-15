from django.conf import settings


def get_currency(request):
    if 'currency' in request.session:
        return request.session['currency']
    else:
        return settings.PRIMARY_CURRENCY