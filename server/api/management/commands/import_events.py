import csv
import os
from django.core.management.base import BaseCommand
from api.models import Event


class Command(BaseCommand):
    help = 'Import events from CSV file into database'

    def add_arguments(self, parser):
        parser.add_argument(
            'csv_file',
            type=str,
            help='Path to the CSV file containing events data'
        )

    def handle(self, *args, **options):
        csv_file = options['csv_file']

        # Check if file exists
        if not os.path.exists(csv_file):
            self.stdout.write(
                self.style.ERROR(f"File '{csv_file}' does not exist")
            )
            return

        try:
            with open(csv_file, 'r', encoding='utf-8') as file:
                reader = csv.DictReader(file)

                # Debug: show headers
                self.stdout.write(f"CSV Headers: {reader.fieldnames}")

                count = 0
                for row in reader:
                    try:
                        Event.objects.create(
                            Name_of_Incident=row.get('Name of Incident', ''),
                            Date=row.get('Date', ''),
                            Month=row.get('Month', ''),
                            Year=row.get('Year', ''),
                            Country=row.get('Country', ''),
                            Type_of_Event=row.get('Type of Event', ''),
                            Place_Name=row.get('Place Name', ''),
                            Impact=row.get('Impact', ''),
                            Affected_Population=row.get('Affected Population', ''),
                            Important_Person_Group_Responsible=row.get(
                                'Important Person/Group Responsible', ''
                            ),
                            Outcome=row.get('Outcome', ''),
                        )

                        count += 1
                        if count % 100 == 0:
                            self.stdout.write(f"Imported {count} events...")

                    except Exception as e:
                        self.stdout.write(
                            self.style.WARNING(
                                f"Error importing event: {row.get('Name_of_Incident', 'Unknown')} - {str(e)}"
                            )
                        )

                self.stdout.write(
                    self.style.SUCCESS(
                        f"Successfully imported {count} events from {csv_file}"
                    )
                )

        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f"Error reading CSV file: {str(e)}")
            )
