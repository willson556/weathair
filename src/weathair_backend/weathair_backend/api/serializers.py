from rest_framework import serializers

from .models import AirNowObservation, AirNowForecastSource, AirNowReportingArea


class AirNowForecastSourceSerializer(serializers.ModelSerializer):
    class Meta:
        model = AirNowForecastSource
        fields = ['name']


class AirNowReportingAreaSerializer(serializers.ModelSerializer):
    class Meta:
        model = AirNowReportingArea
        fields = ['name', 'state_code', 'location']


class AirNowObservationSerializer(serializers.ModelSerializer):
    reporting_area = AirNowReportingAreaSerializer(read_only=True)
    source = AirNowForecastSourceSerializer(read_only=True)

    class Meta:
        model = AirNowObservation
        fields = ['reporting_area', 'issued_date', 'valid_date', 'record_sequence', 'parameter_name',
                  'aqi_value', 'aqi_category', 'primary_pollutant', 'type', 'discussion', 'source']
