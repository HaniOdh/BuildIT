from django.urls import path
from .views import get_Person
from .views import get_person_by_country
from .views import get_Event 

urlpatterns = [
    path('person/',get_Person, name='get_Person'),
    path('person/<int:pk>',get_Person, name='get_Person'),
    path('person/country/', get_person_by_country),
    path('event/',get_Event, name='get_Event'),


]