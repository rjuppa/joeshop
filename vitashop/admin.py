from django.contrib import admin

from models import MyProduct, Category

class MyProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'unit_price', 'discount', 'weight', 'active')

    #fields = ('name', 'unit_price', 'discount', 'active')

admin.site.register(MyProduct, MyProductAdmin)
admin.site.register(Category)