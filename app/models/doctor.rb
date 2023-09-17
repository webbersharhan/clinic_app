class Doctor < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :slot_duration_minutes, numericality: { only_integer: true }, presence: true

  has_many :appointments
  has_many :patients, through: :appointments
  has_many :availabilities, class_name: "DoctorAvailability"
end
