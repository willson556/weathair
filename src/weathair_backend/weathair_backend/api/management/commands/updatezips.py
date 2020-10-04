from django.core.management.base import BaseCommand, CommandError
from ...tasks import update_cityzipcode

class Command(BaseCommand):
    help = 'Updates the zip codes table'

    def handle(self, *args, **options):
        update_cityzipcode()
