require 'rails_helper'

RSpec.describe "Api::V1::Doctors::Appointments", type: :request do
  let!(:doctor) { create(:doctor) }
  let!(:doctor_availability) { create(:doctor_availability, doctor: doctor) }
  let!(:appointment) { create(:appointment, doctor: doctor) }
  let(:valid_attributes) { { patient_id: create(:patient).id, start_time: doctor_availability.start_time, end_time: doctor_availability.start_time + doctor.slot_duration_minutes.minutes, description: "Test Description" } }
  let(:invalid_attributes) { { patient_id: nil, start_time: nil, end_time: nil } }

  describe "GET /index" do
    it "returns a successful response" do
      get api_v1_doctor_appointments_path(doctor_id: doctor.id)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "returns a successful response" do
      get api_v1_doctor_appointment_path(doctor_id: doctor.id, id: appointment.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Appointment" do
        expect {
          post api_v1_doctor_appointments_path(doctor_id: doctor.id), params: { appointment: valid_attributes }
        }.to change(Appointment, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Appointment and returns an error" do
        expect {
          post api_v1_doctor_appointments_path(doctor_id: doctor.id), params: { appointment: invalid_attributes }
        }.to change(Appointment, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /update" do
    context "with valid parameters" do
      let(:new_attributes) { { description: "New Test Description" } }

      it "updates the requested appointment" do
        put api_v1_doctor_appointment_path(doctor_id: doctor.id, id: appointment.id), params: { appointment: new_attributes }
        appointment.reload
        expect(appointment.description).to eq(new_attributes[:description])
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not update the appointment and returns an error" do
        put api_v1_doctor_appointment_path(doctor_id: doctor.id, id: appointment.id), params: { appointment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested appointment" do
      expect {
        delete api_v1_doctor_appointment_path(doctor_id: doctor.id, id: appointment.id)
      }.to change(Appointment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
