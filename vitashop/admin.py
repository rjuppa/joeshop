from django.contrib import admin
from django.conf import settings
from models import MyProduct, Category, PaymentHistory
from shop.models import Order

USER_MODEL = getattr(settings, 'AUTH_USER_MODEL', 'vitashop.MyUser')

class MyProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'unit_price', 'discount', 'weight', 'active')

    #fields = ('name', 'unit_price', 'discount', 'active')

admin.site.register(MyProduct, MyProductAdmin)
admin.site.register(Category)

class SubPaymentHistoryAdmin(admin.TabularInline):
    fields = ('status', 'email', 'wallet_address', 'amount', 'currency')
    model = PaymentHistory
    extra = 0

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ('id', 'created', 'status', 'user', 'order_total', 'shipping_address_text')
    readonly_fields = ('id', 'created', 'status', 'user', 'order_total', 'shipping_address_text')
    fields = ('status',)
    inlines = (SubPaymentHistoryAdmin, )




@admin.register(PaymentHistory)
class PaymentHistoryAdmin(admin.ModelAdmin):
    def order_link(self, obj):
        if obj.order_id:
            return '<a href="/admin/shop/order/%s/" target="_blank">order-%s</a>' % (obj.order_id, obj.order_id)
        else:
            return obj.tracking_number
    order_link.allow_tags = True

    def wallet_address_link(self, obj):
        return '<a href="http://blockchain.info/address/%s" target="_blank">%s&hellip;</a>' % (obj.wallet_address, obj.wallet_address[:16])
    wallet_address_link.allow_tags = True


    list_display = ('id', 'created', 'order', 'status', 'email', 'wallet_address', 'amount', 'currency')
    list_display_links = ('order',)
    readonly_fields = ('id', 'created', 'order_link', 'status', 'email', 'wallet_address', 'amount', 'currency')
    fields = ('id', 'created', 'order_link', 'status', 'email', 'wallet_address', 'amount', 'currency')


