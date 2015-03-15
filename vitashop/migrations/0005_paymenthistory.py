# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('shop', '__first__'),
        ('vitashop', '0004_auto_20150306_2205'),
    ]

    operations = [
        migrations.CreateModel(
            name='PaymentHistory',
            fields=[
                ('orderpayment_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='shop.OrderPayment')),
                ('email', models.EmailField(max_length=75, null=True, verbose_name='Email', blank=True)),
                ('currency', models.CharField(max_length=3, verbose_name='Currency')),
                ('result', models.CharField(max_length=20, verbose_name='Result')),
                ('wallet_address', models.CharField(max_length=34, unique=True, null=True, verbose_name='Wallet address')),
                ('status', models.IntegerField(default=10, verbose_name='Payment status', choices=[(10, 'Created'), (20, 'Unconfirmed'), (30, 'Confirmed'), (40, 'Canceled')])),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='Created')),
            ],
            options={
                'verbose_name': 'Payment History',
                'verbose_name_plural': 'Payment History',
            },
            bases=('shop.orderpayment',),
        ),
    ]
