# Generated by Django 4.2.1 on 2024-01-12 13:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0005_devolucion'),
    ]

    operations = [
        migrations.AlterField(
            model_name='devolucion',
            name='fechaPago',
            field=models.DateField(),
        ),
    ]
