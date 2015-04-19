# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('vitashop', '0006_auto_20150326_2317'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='customer',
            name='newsletter',
        ),
        migrations.AddField(
            model_name='customer',
            name='affiliate',
            field=models.BooleanField(default=False, verbose_name='Affiliate'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='customer',
            name='has_newsletter',
            field=models.BooleanField(default=True, verbose_name='Newsletter'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='customer',
            name='send_affiliate_email',
            field=models.DateTimeField(null=True, verbose_name='Affiliate_email'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='customer',
            name='slag',
            field=models.CharField(max_length=5, unique=True, null=True, verbose_name='Slag'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='customer',
            name='total_sale',
            field=models.DecimalField(default=0, verbose_name='Total Sale', max_digits=11, decimal_places=4),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='paymenthistory',
            name='order_price',
            field=models.DecimalField(default=0, verbose_name='Price', max_digits=11, decimal_places=4),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='paymenthistory',
            name='currency',
            field=models.CharField(default=b'CZK', max_length=3, verbose_name='Currency'),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='paymenthistory',
            name='result',
            field=models.CharField(default=b'', max_length=20, verbose_name='Result'),
            preserve_default=True,
        ),
    ]
