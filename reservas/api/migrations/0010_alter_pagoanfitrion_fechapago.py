# Generated by Django 4.2.1 on 2024-01-12 13:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0009_alter_devolucion_fechapago'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pagoanfitrion',
            name='fechaPago',
            field=models.DateField(blank=True),
        ),
    ]
