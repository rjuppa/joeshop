# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('vitashop', '0005_paymenthistory'),
    ]

    operations = [
        migrations.AddField(
            model_name='myuser',
            name='code',
            field=models.CharField(max_length=40, verbose_name='code', blank=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='myuser',
            name='is_affiliate',
            field=models.BooleanField(default=False, verbose_name='affiliate'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='myuser',
            name='lang',
            field=models.CharField(max_length=2, verbose_name='lang', blank=True),
            preserve_default=True,
        ),
    ]
