# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('vitashop', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Customer',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('email', models.EmailField(unique=True, max_length=255, verbose_name='Email')),
                ('language', models.CharField(max_length=2, verbose_name='Language')),
                ('currency', models.CharField(max_length=3, verbose_name='Currency')),
                ('newsletter', models.CharField(max_length=3, verbose_name='Newsletter')),
                ('discount', models.DecimalField(default=0, verbose_name='Discount', max_digits=5, decimal_places=2)),
                ('parent', models.ForeignKey(verbose_name='Parent', blank=True, to='vitashop.Customer', null=True)),
                ('user', models.ForeignKey(verbose_name='User', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'Customer',
                'verbose_name_plural': 'Customers',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ShoppingHistory',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('quantity', models.PositiveIntegerField(default=1, verbose_name='Quantity')),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='Created')),
                ('customer', models.ForeignKey(verbose_name='Customer', to='vitashop.Customer')),
                ('product', models.ForeignKey(verbose_name='Product', to='vitashop.MyProduct')),
            ],
            options={
                'verbose_name': 'ShoppingHistory',
                'verbose_name_plural': 'ShoppingHistory',
            },
            bases=(models.Model,),
        ),
        migrations.AlterField(
            model_name='category',
            name='active',
            field=models.BooleanField(default=True, verbose_name='Active'),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='category',
            name='image',
            field=models.CharField(max_length=255, null=True, verbose_name='Image', blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='category',
            name='intro',
            field=models.CharField(max_length=255, null=True, verbose_name='Intro', blank=True),
            preserve_default=True,
        ),
    ]
