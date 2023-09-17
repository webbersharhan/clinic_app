# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# Create patients
patients_data = [
  { first_name: 'Webber', last_name: 'Sharhan', email: 'webb@yopmail.com' },
  { first_name: 'Sam', last_name: 'Smith', email: 'sam@yopmail.com' },
  { first_name: 'Bryan', last_name: 'Cranston', email: 'bryan@yopmail.com' }
]

patients = patients_data.map do |patient_data|
  Patient.find_or_create_by!(email: patient_data[:email]) do |patient|
    patient.first_name = patient_data[:first_name]
    patient.last_name = patient_data[:last_name]
  end
end

# Create doctors and their availabilities and appointments
doctors_data = [
  {
    first_name: 'Gregory', last_name: 'House', email: 'greg@yopmail.com',
    slot_duration_minutes: 15,
    availabilities: [
      { date: Time.zone.tomorrow, start_time: "09:00:00", end_time: "12:00:00" },
      { date: Time.zone.tomorrow, start_time: "13:00:00", end_time: "17:00:00" },
      { date: Time.zone.tomorrow + 2.days, start_time: "09:00:00", end_time: "11:00:00" },
      { date: Time.zone.tomorrow + 2.days, start_time: "12:00:00", end_time: "17:00:00" },
      { date: Time.zone.tomorrow + 3.days, start_time: "09:00:00", end_time: "10:00:00" },
      { date: Time.zone.tomorrow + 3.days, start_time: "12:00:00", end_time: "17:00:00" }
    ],
    appointments: [
      { date: Time.zone.tomorrow, patient: patients[0], start_time: "10:00:00", end_time: "10:15:00", description: 'I need a physical' },
      { date: Time.zone.tomorrow, patient: patients[1], start_time: "10:15:00", end_time: "10:30:00", description: 'I need a physical' },
      { date: Time.zone.tomorrow + 2.days, patient: patients[0], start_time: "12:15:00", end_time: "12:30:00", description: 'Consultation' },
      { date: Time.zone.tomorrow + 3.days, patient: patients[1], start_time: "09:15:00", end_time: "09:30:00", description: 'Blood test' },
      { date: Time.zone.tomorrow + 3.days, patient: patients[2], start_time: "14:15:00", end_time: "14:30:00", description: 'Follow-up' }
    ]
  },
  {
    first_name: 'Ish', last_name: 'Salim', email: 'ish@yopmail.com',
    slot_duration_minutes: 30,
    availabilities: [
      { date: Time.zone.tomorrow, start_time: "09:00:00", end_time: "12:00:00" },
      { date: Time.zone.tomorrow + 1.day, start_time: "14:00:00", end_time: "18:00:00" }
    ],
    appointments: [
      { date: Time.zone.tomorrow, patient: patients[1], start_time: "10:30:00", end_time: "11:00:00", description: 'Consultation' },
      { date: Time.zone.tomorrow, patient: patients[2], start_time: "11:00:00", end_time: "11:30:00", description: 'Follow-up' },
      { date: Time.zone.tomorrow + 1.day, patient: patients[1], start_time: "14:30:00", end_time: "15:00:00", description: 'Blood test' },
      { date: Time.zone.tomorrow + 1.day, patient: patients[0], start_time: "16:00:00", end_time: "16:30:00", description: 'I need a physical' }
    ]
  },
  {
    first_name: 'Suh', last_name: 'Salim', email: 'suh@yopmail.com',
    slot_duration_minutes: 20,
    availabilities: [
      { date: Time.zone.tomorrow, start_time: "10:00:00", end_time: "14:00:00" },
      { date: Time.zone.tomorrow + 2.days, start_time: "13:00:00", end_time: "17:00:00" }
    ],
    appointments: [
      { date: Time.zone.tomorrow, patient: patients[0], start_time: "10:20:00", end_time: "10:40:00", description: 'Routine checkup' },
      { date: Time.zone.tomorrow, patient: patients[2], start_time: "12:00:00", end_time: "12:20:00", description: 'Blood test' },
      { date: Time.zone.tomorrow + 2.days, patient: patients[1], start_time: "13:20:00", end_time: "13:40:00", description: 'Consultation'},
      { date: Time.zone.tomorrow + 2.days, patient: patients[2], start_time: "16:40:00", end_time: "17:00:00", description: 'Follow-up' }
    ]
  }
]


doctors_data.each do |doctor_data|
  doctor = Doctor.find_or_create_by!(email: doctor_data[:email]) do |doc|
    doc.first_name = doctor_data[:first_name]
    doc.last_name = doctor_data[:last_name]
    doc.slot_duration_minutes = doctor_data[:slot_duration_minutes]
  end

  doctor_data[:availabilities].each do |availability_data|
    date = availability_data[:date]
    DoctorAvailability.find_or_create_by!(doctor: doctor, date: date, start_time: "#{date} #{availability_data[:start_time]}") do |availability|
      availability.end_time = "#{date} #{availability_data[:end_time]}"
    end
  end

  doctor_data[:appointments].each do |appointment_data|
    date = appointment_data[:date].to_date
    start_time = "#{date} #{appointment_data[:start_time]}"
    end_time = "#{date} #{appointment_data[:end_time]}"
    Appointment.find_or_create_by!(doctor: doctor, patient: appointment_data[:patient], start_time: start_time, end_time: end_time) do |appointment|
      appointment.description = appointment_data[:description]
    end
  end
end














