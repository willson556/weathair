from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.geos import Point
from rest_framework import viewsets
from rest_framework import permissions
from rest_framework import serializers
from rest_framework.exceptions import NotFound
from pandas import isnull
from pandas.core.series import Series

import pgeocode

from .models import AirNowObservation, AirNowReportingArea, AirNowReportingAreaZipCode
from .serializers import AirNowObservationSerializer


class AllObservations(viewsets.ModelViewSet):
    queryset = AirNowObservation.objects.prefetch_related(
        'reporting_area', 'source').all()
    serializer_class = AirNowObservationSerializer
    permission_classes = [permissions.AllowAny]


class ObservationsForZip(viewsets.ModelViewSet):
    serializer_class = AirNowObservationSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        zipcode_string = self.request.query_params.get('zipcode', None)

        if zipcode_string is None:
            raise serializers.ValidationError('A zipcode must be provided.')

        try:
            zipcode = int(zipcode_string)
        except ValueError as value_error:
            raise serializers.ValidationError(
                f'Zipcode is in an invalid format and could not be parsed: {value_error}')

        reporting_area_location = AirNowReportingAreaZipCode.objects.filter(
            zipcode=zipcode).first()

        if reporting_area_location is None:
            # no exact match, we'll look for the nearest reporting area to the zip code centroid.
            country = pgeocode.Nominatim('us')
            locale = country.query_postal_code(zipcode)

            longitude = locale['longitude']
            latitude = locale['latitude']

            if not isinstance(locale, Series) or isnull(longitude) or isnull(latitude):
                raise NotFound(f'No location found for {zipcode}.')

            zipcode_center = Point(longitude, latitude, srid=4236)
            reporting_area = AirNowReportingArea.objects.annotate(
                distance=Distance('location', zipcode_center)).order_by('distance').first()
        else:
            reporting_area = AirNowReportingArea.objects.filter(
                name=reporting_area_location.city,
                state_code=reporting_area_location.state).first()

        return AirNowObservation.objects.filter(reporting_area=reporting_area)
