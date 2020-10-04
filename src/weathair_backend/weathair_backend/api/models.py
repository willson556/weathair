from django.contrib.gis.db import models

class AirNowForecastSource(models.Model):
    name = models.CharField(max_length=100)

class AirNowReportingArea(models.Model):
    name = models.CharField(max_length=100, db_index=True)
    state_code = models.CharField(max_length=2, db_index=True)
    location = models.PointField(spatial_index=True)

    class Meta:
        indexes = [
            models.Index(fields=['name', 'state_code']),
        ]

class AirNowObservation(models.Model):
    reporting_area = models.ForeignKey(AirNowReportingArea, on_delete=models.CASCADE)

    issued_date = models.DateTimeField()
    valid_date = models.DateTimeField()
    record_sequence = models.SmallIntegerField()

    parameter_name = models.CharField(max_length=10)
    aqi_value = models.SmallIntegerField(null=True)
    aqi_category = models.CharField(max_length=40)
    primary_pollutant = models.BooleanField()
    
    class Type(models.TextChoices):
        FORECAST = 'F'
        YESTERDAY = 'Y'
        HOURLY_OBSERVATION = 'O'

    type = models.CharField(max_length=1, choices=Type.choices)

    discussion = models.TextField(null=True)
    source = models.ForeignKey(AirNowForecastSource, on_delete=models.CASCADE)

class AirNowReportingAreaZipCode(models.Model):
    city = models.CharField(max_length=100, db_index=True)
    state = models.CharField(max_length=2)
    zipcode = models.IntegerField(db_index=True, unique=True)
    location = models.PointField()
