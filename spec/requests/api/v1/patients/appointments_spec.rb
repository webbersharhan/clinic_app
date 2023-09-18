require 'rails_helper'

RSpec.describe 'Api::V1::Patients::Appointments', type: :request do
  let!(:patient) { create(:patient) }
  let!(:doctor) { create(:doctor) }
  let(:date) { Time.zone.tomorrow }
  let!(:doctor_availability) { create(:doctor_availability, doctor: doctor, date: date) }
  let!(:appointment) { create(:appointment, patient: patient ) }
  let(:start_time) { "#{Time.zone.tomorrow} 10:30:00"}
  let(:end_time) { "#{Time.zone.tomorrow} 10:45:00"}
  let(:valid_attributes) do
    {
      doctor_id: doctor.id,
      start_time: start_time,
      end_time: end_time,
      description: "Checkup"
    }
  end

  describe 'GET /api/v1/patients/:patient_id/appointments' do
    before { get api_v1_patient_appointments_path(patient) }

    it 'returns the appointments for a given patient' do
      expect(response.body).to include(appointment.description)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/patients/:patient_id/appointments/:id' do
    before { get api_v1_patient_appointment_path(patient, appointment) }

    it 'returns the appointment details' do
      expect(response.body).to include(appointment.description)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /api/v1/patients/:patient_id/appointments' do
    context 'when valid attributes are provided' do
      before { post api_v1_patient_appointments_path(patient), params: { appointment: valid_attributes } }

      it 'creates an appointment' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when invalid attributes are provided' do
      before { post api_v1_patient_appointments_path(patient), params: { appointment: { description: 'Only description' } } }

      it 'does not create an appointment and returns errors' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /api/v1/patients/:patient_id/appointments/:id' do
    let(:new_attributes) { { description: 'New appointment description' } }
    
    before { put api_v1_patient_appointment_path(patient, appointment), params: { appointment: new_attributes } }

    it 'updates the appointment' do
      appointment.reload
      expect(appointment.description).to eq('New appointment description')
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /api/v1/patients/:patient_id/appointments/:id' do
    before { delete api_v1_patient_appointment_path(patient, appointment) }

    it 'deletes the appointment' do
      expect(response).to have_http_status(204)
      expect(Appointment.exists?(appointment.id)).to be_falsey
    end
  end
end
