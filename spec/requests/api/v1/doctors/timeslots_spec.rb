require 'rails_helper'

RSpec.describe "Api::V1::Doctors::Timeslots", type: :request do
  let(:doctor) { create(:doctor, slot_duration_minutes: 30) }
  let(:date) { Date.tomorrow }

  before do
    create(:doctor_availability, doctor: doctor, start_time: "#{date} 09:00:00", end_time: "#{date} 11:00:00", date: date)
  end

  describe 'GET /api/v1/doctors/:doctor_id/timeslots' do
    context 'with valid doctor_id' do
      before do
        create(:appointment, doctor: doctor, start_time: "#{date} 09:00:00", end_time: "#{date} 09:30:00")
        create(:appointment, doctor: doctor, start_time: "#{date} 10:00:00", end_time: "#{date} 10:30:00")
        get api_v1_doctor_timeslots_path(doctor_id: doctor, date: date)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns available timeslots' do
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context 'with invalid doctor_id' do
      before do
        get api_v1_doctor_timeslots_path(doctor_id: 'invalid_id')
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found error message' do
        expect(response.body).to match(/Doctor not found/)
      end
    end
  end
end

