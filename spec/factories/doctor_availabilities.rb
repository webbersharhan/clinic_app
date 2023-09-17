FactoryBot.define do
  factory :doctor_availability do
    doctor
    date { Time.zone.tomorrow }
    start_time { Time.zone.tomorrow.beginning_of_day + 9.hours } 
    end_time { Time.zone.tomorrow.beginning_of_day + 17.hours }
  end
end
