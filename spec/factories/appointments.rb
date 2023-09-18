FactoryBot.define do
  factory :appointment do
    doctor
    patient

    after(:build) do |appointment|
      unless appointment.doctor.availabilities.present?
        create(:doctor_availability, doctor: appointment.doctor)
      end
    end
    
    start_time  { Time.zone.tomorrow.beginning_of_day + 10.hours }
    end_time do
      start_time + doctor.slot_duration_minutes.minutes
    end

    description { "Consultation" }
  end
end
