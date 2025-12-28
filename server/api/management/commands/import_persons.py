import csv
import os
from django.core.management.base import BaseCommand
from api.models import Person  # Note: import from 'api.models'

class Command(BaseCommand):
    help = 'Import historical persons from CSV file into database'
    
    def add_arguments(self, parser):
        parser.add_argument(
            'csv_file',
            type=str,
            help='Path to the CSV file containing persons data'
        )
    
    def handle(self, *args, **options):
        csv_file = options['csv_file']
        
        # Check if file exists
        if not os.path.exists(csv_file):
            self.stdout.write(self.style.ERROR(f"File '{csv_file}' does not exist"))
            return
        
        try:
            with open(csv_file, 'r', encoding='utf-8') as file:
                # Read CSV
                reader = csv.DictReader(file)
                
                # Print headers for debugging
                self.stdout.write(f"CSV Headers: {reader.fieldnames}")
                
                count = 0
                for row in reader:
                    try:
                        # Create person object
                        person = Person.objects.create(
                            id=int(row['id']) if row.get('id') else None,
                            Name=row.get('Name', ''),
                            Occupation=row.get('Occupation', ''),
                            Birth_Year=row.get('Birth Year', ''),
                            Death_Year=row.get('Death Year', ''),
                            Gender=row.get('Gender', ''),
                            Birth_City=row.get('Birth City', ''),
                            Birth_Country=row.get('Birth Country', ''),
                            Death_City=row.get('Death City', ''),
                            Death_Country=row.get('Death Country', ''),
                        )
                        count += 1
                        
                        if count % 100 == 0:
                            self.stdout.write(f"Imported {count} persons...")
                            
                    except Exception as e:
                        self.stdout.write(
                            self.style.WARNING(f"Error importing row: {row.get('Name', 'Unknown')} - {str(e)}")
                        )
                
                self.stdout.write(
                    self.style.SUCCESS(f"Successfully imported {count} persons from {csv_file}")
                )
                
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"Error reading CSV file: {str(e)}"))