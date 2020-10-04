from django.core.management.base import BaseCommand
from ...tasks import update_aqi

class Command(BaseCommand):
    help = 'Updates the aqi data'

    def handle(self, *args, **options):
        update_aqi()
