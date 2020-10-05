from django.urls import include, path
from rest_framework import routers

from . import views

router = routers.DefaultRouter()
router.register(r'observations', views.AllObservations)
router.register(r'observations-for-zip', views.ObservationsForZip, basename='AirNowObservation')

urlpatterns = [
    path('', include(router.urls)),
]