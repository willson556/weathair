from contextlib import closing
from datetime import datetime
from django.contrib.gis.geos import Point
from django.db import transaction
from bulk_sync import bulk_sync
from pandas import isnull

import codecs
import csv
import dateparser
import requests
import pandas as pd
import pytz

from .models import AirNowForecastSource, AirNowReportingArea, AirNowReportingAreaZipCode, AirNowObservation

CITY_ZIPCODES_URL = "https://files.airnowtech.org/airnow/today/cityzipcodes.csv"

AQI_DATA_URL = "https://s3-us-west-1.amazonaws.com//files.airnowtech.org/airnow/today/reportingarea.dat"
AQI_DATA_COLUMN_NAMES = [
    'IssueDate',
    'ValidDate',
    'ValidTime',
    'TimeZone',
    'RecordSequence',
    'DataType',
    'Primary',
    'ReportingArea',
    'StateCode',
    'Latitude',
    'Longitude',
    'ParameterName',
    'AQIValue',
    'AQICategory',
    'ActionDay',
    'Discussion',
    'ForecastSource',
]

AQI_DATA_DATES = {
    'IssueDateTime': [0],
}

TIMEZONE_CONVERSIONS = {
    # The Alaska time zones don't seem to be reported correctly.
    'AKT': 'AKST',
    'ADT': 'AKDT',
}


def _print_status(status):
    print("Results of bulk_sync: "
          "{created} created, {updated} updated, {deleted} deleted."
          .format(**status['stats']))


def _find_first(items, condition):
    return next((i for i in items if condition(i)))


def _convert_valid_time(obs):
    if isnull(obs['ValidTime']) or isnull(obs['TimeZone']):
        return datetime.strptime(obs['ValidDate'], '%m/%d/%y')

    timezone = obs["TimeZone"]
    timezone = TIMEZONE_CONVERSIONS.get(
        timezone, timezone)  # Convert if possible

    datestring = f'{obs["ValidDate"]} {obs["ValidTime"]} {timezone}'
    date = dateparser.parse(datestring, settings={'DATE_ORDER': 'MDY'})

    if date is None:
        raise Exception('Date is invalid!', datestring)

    return date


def _ensure_tz_aware(dt):
    return dt if dt.tzinfo is not None else dt.replace(tzinfo=pytz.UTC)


def update_cityzipcode():
    with closing(requests.get(CITY_ZIPCODES_URL, stream=True)) as source:
        reader = csv.DictReader(codecs.iterdecode(
            source.iter_lines(), 'utf-8'), delimiter='|')
        new_models = [AirNowReportingAreaZipCode(city=row['City'],
                                                 state=row['State'],
                                                 zipcode=int(row['Zipcode']),
                                                 location=Point(float(row['Longitude']), float(row['Latitude'])))
                      for row in reader]

    _print_status(bulk_sync(new_models, ('zipcode', ), None))


def _convert_observation(o, reporting_areas_db, forecast_sources_db):
    try:
        return AirNowObservation(reporting_area=_find_first(reporting_areas_db,
                                                            lambda a: a.name == o['ReportingArea'] and a.state_code == o['StateCode']), # TODO Might be faster to store in a dictionary.
                                 issued_date=_ensure_tz_aware(
                                     o['IssueDateTime'].to_pydatetime()),
                                 valid_date=_ensure_tz_aware(
                                     _convert_valid_time(o)),
                                 record_sequence=o['RecordSequence'],
                                 parameter_name=o['ParameterName'],
                                 aqi_value=o['AQIValue'] if not isnull(
                                     o['AQIValue']) else None,
                                 aqi_category=o['AQICategory'],
                                 primary_pollutant=o['Primary'] == 'Y',
                                 type=o['DataType'],
                                 discussion=o['Discussion'] if not isnull(
                                     o['Discussion']) else None,
                                 source=_find_first(forecast_sources_db,
                                                    lambda s: s.name == o['ForecastSource'])) # TODO Might be faster to store in a dictionary.
    except:
        return None # TODO Logging


@transaction.atomic
def update_aqi():
    dataframe = pd.read_csv(AQI_DATA_URL, delimiter='|', usecols=range(17), names=AQI_DATA_COLUMN_NAMES,
                            header=None, parse_dates=AQI_DATA_DATES, infer_datetime_format=True, dayfirst=False)

    reporting_areas = [AirNowReportingArea(name=area[0],
                                           state_code=area[1],
                                           location=Point(float(area[3]), float(area[2])))
                       for (area, _) in dataframe.groupby(['ReportingArea', 'StateCode', 'Latitude', 'Longitude'])]

    _print_status(bulk_sync(reporting_areas, ('name', 'state_code'), None))

    forecast_sources = [AirNowForecastSource(name=name) for (
        name, _) in dataframe.groupby('ForecastSource')]
    _print_status(bulk_sync(forecast_sources, ('name', ), None))

    reporting_areas_db = list(AirNowReportingArea.objects.all())
    forecast_sources_db = list(AirNowForecastSource.objects.all())

    observations = [_convert_observation(o, reporting_areas_db, forecast_sources_db) for (
        _, o) in dataframe.iterrows() if o['StateCode'] != '  ']
    observations = [
        observation for observation in observations if observation is not None]
    _print_status(bulk_sync(observations, ('reporting_area_id', 'issued_date', 'valid_date', 'record_sequence',
                                           'parameter_name', 'aqi_value', 'aqi_category', 'primary_pollutant', 'type'), None))
