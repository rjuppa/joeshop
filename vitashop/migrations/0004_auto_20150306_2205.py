# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('vitashop', '0003_auto_20150306_2152'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='myuser',
            table='vitashop_myuser',
        ),
    ]
