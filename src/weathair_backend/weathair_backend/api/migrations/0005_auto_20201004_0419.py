# Generated by Django 3.1.2 on 2020-10-04 04:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_auto_20201004_0412'),
    ]

    operations = [
        migrations.AlterField(
            model_name='airnowreportingarea',
            name='name',
            field=models.CharField(db_index=True, max_length=100),
        ),
    ]
