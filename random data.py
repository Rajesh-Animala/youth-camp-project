import random
from faker import Faker

fake = Faker()

# Define gender distribution
total_records = 5000
female_count = int(total_records * 0.65)
male_count = total_records - female_count

# Generate participant records
participants = []

for _ in range(female_count):
    first_name = fake.first_name_female()
    last_name = fake.last_name()
    middle_name = fake.first_name_female() if random.random() > 0.5 else ''
    dob = fake.date_of_birth(minimum_age=10, maximum_age=18).strftime('%Y-%m-%d')
    email = fake.email()
    gender = 'Female'
    phone = fake.phone_number()
    participants.append((first_name, middle_name, last_name, dob, email, gender, phone))

for _ in range(male_count):
    first_name = fake.first_name_male()
    last_name = fake.last_name()
    middle_name = fake.first_name_male() if random.random() > 0.5 else ''
    dob = fake.date_of_birth(minimum_age=7, maximum_age=19).strftime('%Y-%m-%d')
    email = fake.email()
    gender = 'Male'
    phone = fake.phone_number()
    participants.append((first_name, middle_name, last_name, dob, email, gender, phone))

# Generate SQL INSERT statements
sql_statements = "INSERT INTO Participants (FirstName, MiddleName, LastName, DateOfBirth, Email, Gender, PersonalPhone) VALUES\n"
values_list = []

for p in participants:
    values_list.append(f"('{p[0]}', '{p[1]}', '{p[2]}', '{p[3]}', '{p[4]}', '{p[5]}', '{p[6]}')")

sql_statements += ",\n".join(values_list) + ";"

# Save to a file
file_path = r"C:\Users\rajes\OneDrive\Documents\sqlproject\youth.sql"

with open(file_path, "w") as file:
    file.write(sql_statements)

file_path
