from contextlib import closing
from django.contrib.gis.geos import Point
from django.db.models import Q
from bulk_sync import bulk_sync

import codecs
import csv
import requests

from .models import AirNowReportingAreaZipCode

def update_cityzipcode():
    with closing(requests.get("https://files.airnowtech.org/airnow/today/cityzipcodes.csv", stream=True)) as source:
        reader = csv.DictReader(codecs.iterdecode(source.iter_lines(), 'utf-8'), delimiter='|')
        new_models = [AirNowReportingAreaZipCode(city=row['City'],
                                                 state=row['State'],
                                                 zipcode=int(row['Zipcode']),
                                                 location=Point(float(row['Latitude']), float(row['Longitude']))) for row in reader]

        key_fields = ('zipcode', )

        ret = bulk_sync(new_models, key_fields, None)

        print("Results of bulk_sync: "
              "{created} created, {updated} updated, {deleted} deleted."
              .format(**ret['stats']))
