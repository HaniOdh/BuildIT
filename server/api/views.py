from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from .models import Person
from .models import Event
from .serializer import PersonSerializer
from .serializer import EventSerializer




@api_view(['GET'])
def get_Person(request, pk):
    person = Person.objects.get(pk=pk)
    Serializer = PersonSerializer(person)
    return Response(Serializer.data)

@api_view(['GET'])
def get_person_by_country(request):
    birth_country = request.GET.get("Birth_Country")
    birth_city = request.GET.get("Birth_City")

    queryset = Person.objects.all()

    if birth_country:
        queryset = queryset.filter(
            Birth_Country__iexact=birth_country
        )

    if birth_city:
        queryset = queryset.filter(
            Birth_City__iexact=birth_city
        )

    serializer = PersonSerializer(queryset, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def get_Event(request):
    Country = request.GET.get("Country")
    Place_Name = request.GET.get("Place_Name")

    queryset = Event.objects.all()

    if Country:
        queryset = queryset.filter(
            Country__iexact=Country
        )

    if Place_Name:
        queryset = queryset.filter(
            Place_Name__iexact=Place_Name
        )

    serializer = EventSerializer(queryset, many=True)
    return Response(serializer.data)



