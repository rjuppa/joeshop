# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('shop', '__first__'),
    ]

    operations = [
        migrations.CreateModel(
            name='Category',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=255, verbose_name='Name')),
                ('slug', models.SlugField(unique=True, verbose_name='Slug')),
                ('active', models.BooleanField(default=False, verbose_name='Active')),
                ('image', models.CharField(max_length=255, verbose_name='Image')),
                ('intro', models.CharField(max_length=255, verbose_name='Intro')),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='Created')),
            ],
            options={
                'verbose_name': 'Category',
                'verbose_name_plural': 'Categories',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='MyProduct',
            fields=[
                ('product_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='shop.Product')),
                ('image', models.CharField(max_length=255, verbose_name='Image')),
                ('intro', models.CharField(max_length=255, verbose_name='Intro')),
                ('link', models.CharField(max_length=255, null=True, verbose_name='Link', blank=True)),
                ('desc1', models.CharField(max_length=2000, null=True, verbose_name='Desc1', blank=True)),
                ('desc2', models.CharField(max_length=2000, null=True, verbose_name='Desc2', blank=True)),
                ('desc3', models.CharField(max_length=2000, null=True, verbose_name='Desc3', blank=True)),
                ('filter1', models.CharField(max_length=255, null=True, verbose_name='Filter1', blank=True)),
                ('filter2', models.CharField(max_length=255, null=True, verbose_name='Filter2', blank=True)),
                ('is_featured', models.BooleanField(default=False, verbose_name='Featured')),
                ('weight', models.DecimalField(default=0, verbose_name='Weight', max_digits=5, decimal_places=2)),
                ('old_price', models.DecimalField(default=0, verbose_name='Old Price', max_digits=5, decimal_places=2)),
                ('discount', models.DecimalField(default=0, verbose_name='Discount', max_digits=5, decimal_places=2)),
                ('ordering', models.PositiveIntegerField(null=True, verbose_name='Ordering', blank=True)),
                ('category', models.ForeignKey(verbose_name='Category', blank=True, to='vitashop.Category', null=True)),
            ],
            options={
                'verbose_name': 'Product',
                'verbose_name_plural': 'Products',
            },
            bases=('shop.product',),
        ),
    ]
