require 'rails_helper'

RSpec.describe DoctorAvailability, type: :model do

  describe 'validations' do
    let!(:doctor) { create(:doctor) }

    context 'when checking for overlapping availabilities' do
      let(:nine_am) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 9).utc }
      let(:ten_am) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 10).utc }
      let(:eleven_am) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 11).utc }
      let(:noon) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 12).utc }
      let(:two_pm) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 14).utc }

      before do 
        create(:doctor_availability, doctor: doctor, start_time: nine_am, end_time: eleven_am)
      end

      it 'is invalid when the availability overlaps with an existing one' do
        overlapping_availability = build(:doctor_availability, doctor: doctor, start_time: ten_am, end_time: noon)
        expect(overlapping_availability).not_to be_valid
        expect(overlapping_availability.errors[:base]).to include("The availability overlaps with another time slot.")
      end

      it 'is valid when the availability does not overlap' do
        non_overlapping_availability = build(:doctor_availability, doctor: doctor, start_time: noon, end_time: two_pm)
        expect(non_overlapping_availability).to be_valid
      end
    end

    context 'when checking for conflicts with existing appointments on update' do
      let(:start_time) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 13).utc }
      let(:end_time) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 15).utc }
      let(:appointment_start_time) { start_time + 15.minutes }
      let(:appointment_end_time) { start_time + 30.minutes }
      
      let(:appointment) { create(:appointment, doctor: doctor, start_time: appointment_start_time, end_time: appointment_end_time) }
      let!(:existing_availability) { create(:doctor_availability, doctor: doctor) }


      it 'is invalid when updating availability to a slot that conflicts with an existing appointment' do
        appointment
        existing_availability.start_time = appointment_start_time
        existing_availability.end_time = appointment_end_time
        expect(existing_availability).not_to be_valid
        expect(existing_availability.errors[:base]).to include("Cannot update availability as it conflicts with existing appointments.")
      end

      it 'is valid when updating to a time that does not conflict' do
        appointment
        existing_availability.start_time = Time.zone.tomorrow.at_beginning_of_day.advance(hours: 18).utc
        existing_availability.end_time = Time.zone.tomorrow.at_beginning_of_day.advance(hours: 19).utc
        expect(existing_availability).to be_valid
      end
    end
  end
end
