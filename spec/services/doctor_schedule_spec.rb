require 'rails_helper'

RSpec.describe DoctorSchedule do
  let(:doctor) { create(:doctor, slot_duration_minutes: 30) }
  let(:date) { Date.tomorrow }
  let(:service) { DoctorSchedule.new(doctor, date) }

  before do
    create(:doctor_availability, doctor: doctor, start_time: "#{date} 09:00:00", end_time: "#{date} 11:00:00", date: date)
  end

  describe '#available_slots' do
    context 'when no appointments are booked' do
      it 'returns all the slots for the doctor' do
        expect(service.available_slots).to eq([
          ['09:00:00', '09:30:00'],
          ['09:30:00', '10:00:00'],
          ['10:00:00', '10:30:00'],
          ['10:30:00', '11:00:00']
        ])
      end
    end

    context 'when an appointment is booked' do
      before do
        # An appointment from 9:30 AM to 10:00 AM
        create(:appointment, doctor: doctor, start_time: "#{date} 09:30:00", end_time: "#{date} 10:00:00")
      end

      it 'excludes the booked slot' do
        expect(service.available_slots).to eq([
          ['09:00:00', '09:30:00'],
          ['10:00:00', '10:30:00'],
          ['10:30:00', '11:00:00']
        ])
      end
    end

    context 'when multiple appointments are booked' do
      before do
        # Two appointments: one from 9:00 AM to 9:30 AM and another from 10:00 AM to 10:30 AM
        create(:appointment, doctor: doctor, start_time: "#{date} 09:00:00", end_time: "#{date} 09:30:00")
        create(:appointment, doctor: doctor, start_time: "#{date} 10:00:00", end_time: "#{date} 10:30:00")
      end
  
      it 'excludes both the booked slots' do
        expect(service.available_slots).to eq([
          ['09:30:00', '10:00:00'],
          ['10:30:00', '11:00:00']
        ])
      end
    end

    context 'when all slots are booked' do
      before do
        create(:appointment, doctor: doctor, start_time: "#{date} 09:00:00", end_time: "#{date} 09:30:00")
        create(:appointment, doctor: doctor, start_time: "#{date} 09:30:00", end_time: "#{date} 10:00:00")
        create(:appointment, doctor: doctor, start_time: "#{date} 10:00:00", end_time: "#{date} 10:30:00")
        create(:appointment, doctor: doctor, start_time: "#{date} 10:30:00", end_time: "#{date} 11:00:00")
      end
  
      it 'returns an empty array' do
        expect(service.available_slots).to be_empty
      end
    end

  end
end