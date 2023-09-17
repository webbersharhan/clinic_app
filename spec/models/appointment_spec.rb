require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'validations' do
    subject { build(:appointment) }

    context 'non_overlapping' do
      let!(:existing_appointment) { create(:appointment) }

      it 'is not valid when overlapping with another appointment for the same patient' do
        overlapping_appointment = build(:appointment, patient: existing_appointment.patient, start_time: existing_appointment.start_time, end_time: existing_appointment.end_time)
        expect(overlapping_appointment).not_to be_valid
        expect(overlapping_appointment.errors[:base]).to include("The appointment overlaps with another one.")
      end
    end

    context 'within doctor availability' do
      let(:doctor) { create(:doctor) }
      let(:nine_am) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 9).utc }
      let(:ten_am) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 10).utc }
      let(:eleven_am) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 11).utc }
      let(:noon) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 12).utc }
      let(:two_pm) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 14).utc }
    
      before do
        create(:doctor_availability, doctor: doctor, start_time: ten_am, end_time: two_pm)
      end
    
      it 'is valid if the appointment is within the doctor availability' do
        appointment = build(:appointment, doctor: doctor, start_time: eleven_am, end_time: eleven_am + doctor.slot_duration_minutes.minutes)
        expect(appointment).to be_valid
      end
    
      it 'is not valid if the appointment is outside the doctor availability' do
        appointment = build(:appointment, doctor: doctor, start_time: nine_am, end_time: ten_am)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:base]).to include("The appointment time is outside the doctor's availability")
      end
    
      it 'is not valid if the appointment partially overlaps the doctor availability' do
        appointment = build(:appointment, doctor: doctor, start_time: nine_am, end_time: eleven_am)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:base]).to include("The appointment time is outside the doctor's availability")
      end
    end
    

    context 'time and duration checks' do
      let(:slot_duration) { 30 }
      let(:doctor) { create(:doctor, slot_duration_minutes: slot_duration) }
      let(:start_time) { Time.zone.tomorrow.at_beginning_of_day.advance(hours: 10).utc }
      let(:end_time) { start_time + slot_duration.minutes + 10.minutes }
      
      it 'validates start_time_cannot_be_in_the_past' do
        appointment = build(:appointment, doctor: doctor, start_time: 1.day.ago)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:start_time]).to include("can't be in the past")
      end
    
      it 'validates end_time_cannot_be_in_the_past' do
        appointment = build(:appointment, doctor: doctor, end_time: 1.day.ago)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:end_time]).to include("can't be in the past")
      end
      
      it 'validates end_time_after_start_time' do
        appointment = build(:appointment, doctor: doctor, start_time: Time.zone.now + 2.hours, end_time: Time.zone.now + 1.hour)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:end_time]).to include("must be after the start time")
      end
    
      it 'validates start_time_aligned_with_slot' do
        misaligned_start = start_time + slot_duration.minutes + 5.minutes
        appointment = build(:appointment, doctor: doctor, start_time: misaligned_start)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:start_time]).to include("must align with a slot boundary")
      end
    
      it 'validates end_time_aligned_with_slot' do
        misaligned_end = end_time + 5.minutes
        appointment = build(:appointment, doctor: doctor, end_time: misaligned_end)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:end_time]).to include("must align with a slot boundary")
      end
    
      it 'validates duration_matches_slot_duration' do
        appointment = build(:appointment, doctor: doctor, start_time: start_time, end_time: end_time)
        expect(appointment).not_to be_valid
        expect(appointment.errors[:base]).to include("appointment duration must be equal to the doctor's slot duration of #{slot_duration} minutes")
      end
    end 
  end
end

