from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from vitashop.views import index
# from django.conf.urls import handler404, handler500, handler403, handler400
from vitashop.views import error404, error500, error403, error400

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', index, name='shop_welcome'),
    url(r'', include('web.urls')),
    url(r'^shop/', include('vitashop.urls')),
    url(r'^i18n/', include('django.conf.urls.i18n')),
    # url(r'^shop/', include('shop.urls')),
    url(r'^admin/', include(admin.site.urls)),
    url('', include('social.apps.django_app.urls', namespace='social')),
) + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT) + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)



handler404 = error404
handler500 = error500
handler403 = error403
handler400 = error400