from django.db import models


class Person(models.Model):
    Name = models.CharField(max_length=50)
    Occupation = models.CharField(max_length=50)
    Birth_Year = models.CharField(max_length=50)
    Death_Year = models.CharField(max_length=50)
    Gender = models.CharField(max_length=50)
    Birth_City = models.CharField(max_length=50)
    Birth_Country = models.CharField(max_length=50)
    Death_City = models.CharField(max_length=50)
    Death_Country = models.CharField(max_length=50)
    def __str__(self):
        return self.Name
    
class Event(models.Model):
    Name_of_Incident = models.CharField(max_length=50)
    Date = models.CharField(max_length=50)
    Month = models.CharField(max_length=50)
    Year = models.CharField(max_length=50)
    Country = models.CharField(max_length=50)
    Type_of_Event = models.CharField(max_length=50)
    Place_Name = models.CharField(max_length=50)
    Impact = models.CharField(max_length=50)
    Affected_Population = models.CharField(max_length=50)
    Important_Person_Group_Responsible = models.CharField(max_length=50)
    Outcome = models.CharField(max_length=50)

    def __str__(self):
        return self.Name    