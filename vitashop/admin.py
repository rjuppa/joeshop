from django.contrib import admin
from django.conf import settings
from models import MyProduct, Category

USER_MODEL = getattr(settings, 'AUTH_USER_MODEL', 'vitashop.MyUser')

class MyProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'unit_price', 'discount', 'weight', 'active')

    #fields = ('name', 'unit_price', 'discount', 'active')

admin.site.register(MyProduct, MyProductAdmin)
admin.site.register(Category)