# Generated by Django 2.2.6 on 2019-10-28 14:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('newsapi', '0002_articlesfromapi'),
    ]

    operations = [
        migrations.AlterField(
            model_name='articlesfromapi',
            name='articles_author',
            field=models.CharField(blank=True, max_length=40, null=True),
        ),
        migrations.AlterField(
            model_name='articlesfromapi',
            name='articles_description',
            field=models.CharField(blank=True, max_length=1000, null=True),
        ),
        migrations.AlterField(
            model_name='articlesfromapi',
            name='articles_title',
            field=models.CharField(blank=True, max_length=200, null=True),
        ),
        migrations.AlterField(
            model_name='articlesfromapi',
            name='articles_url',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]