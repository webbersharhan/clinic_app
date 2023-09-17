require 'rails_helper'

RSpec.describe "Api::V1::Doctors::DoctorAvailabilities", type: :request do
  let!(:doctor) { create(:doctor) }
  let!(:availability) { create(:doctor_availability, doctor: doctor) }
  
  let(:valid_attributes) {
    { start_time: "09:00", end_time: "17:00", date: Date.tomorrow }
  }

  let(:invalid_attributes) {
    { start_time: nil, end_time: nil, date: nil }
  }

  describe "GET /index" do
    it "returns all doctor availabilities" do
      get api_v1_doctor_availabilities_path(doctor_id: doctor.id)
      expect(response).to be_successful
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "GET /show" do
    it "returns a specific availability" do
      get api_v1_doctor_availability_path(doctor_id: doctor.id, id: availability.id)
      expect(response).to be_successful
      expect(JSON.parse(response.body)["id"]).to eq(availability.id)
    end
  end

  describe "POST /create" do
    context "with valid attributes" do
      it "creates a new availability for the doctor" do
        expect {
          post api_v1_doctor_availabilities_path(doctor_id: doctor.id), params: { availability: valid_attributes }
        }.to change(DoctorAvailability, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new availability and returns an error" do
        expect {
          post api_v1_doctor_availabilities_path(doctor_id: doctor.id), params: { availability: invalid_attributes }
        }.to change(DoctorAvailability, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /update" do
    context "with valid attributes" do
      let(:updated_attributes) { { start_time: "10:00", end_time: "16:00" } }

      it "updates the specific availability" do
        put api_v1_doctor_availability_path(doctor_id: doctor.id, id: availability.id), params: { availability: updated_attributes }
        availability.reload
        expect(availability.start_time.strftime("%H:%M")).to eq("10:00")
        expect(availability.end_time.strftime("%H:%M")).to eq("16:00")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      it "doesn't update the availability and returns an error" do
        put api_v1_doctor_availability_path(doctor_id: doctor.id, id: availability.id), params: { availability: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes a specific availability" do
      expect {
        delete api_v1_doctor_availability_path(doctor_id: doctor.id, id: availability.id)
      }.to change(DoctorAvailability, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
