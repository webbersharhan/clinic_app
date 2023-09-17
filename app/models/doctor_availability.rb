class DoctorAvailability < ApplicationRecord
  belongs_to :doctor
  has_many :appointments, through: :doctor

  validates :start_time, :end_time, :date, presence: true
  validate :no_overlapping_availabilities
  validate :does_not_conflict_with_existing_appointments, on: :update

  private

  def no_overlapping_availabilities
    overlapping_availability = DoctorAvailability
      .where(doctor_id: doctor_id, date: date)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)
      .exists?
    
    errors.add(:base, "The availability overlaps with another time slot.") if overlapping_availability
  end

  def does_not_conflict_with_existing_appointments
    overlapping_appointments = appointments
      .where("start_time < ? AND end_time > ?", end_time, start_time)
    
    if overlapping_appointments.exists?
      errors.add(:base, "Cannot update availability as it conflicts with existing appointments.")
    end
  end
end
