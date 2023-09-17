class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  validate :non_overlapping
  validate :within_doctor_availability

  validate :start_time_aligned_with_slot 
  validate :end_time_aligned_with_slot 
  validate :duration_matches_slot_duration

  validate :start_time_cannot_be_in_the_past
  validate :end_time_cannot_be_in_the_past
  validate :end_time_after_start_time

  private

  def non_overlapping
    overlaps = Appointment
      .where(patient: patient)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)
      .exists?

    errors.add(:base, "The appointment overlaps with another one.") if overlaps
  end

  def within_doctor_availability
    availability = DoctorAvailability
      .where(doctor: doctor)
      .where("start_time <= ? AND end_time >= ?", start_time, end_time)
      .exists?
    
    errors.add(:base, "The appointment time is outside the doctor's availability") unless availability
  end

  def start_time_aligned_with_slot
    if start_time.present? && (start_time.min % slot_duration) != 0
      errors.add(:start_time, "must align with a slot boundary")
    end
  end

  def end_time_aligned_with_slot
    if end_time.present? && (end_time.min % slot_duration) != 0
      errors.add(:end_time, "must align with a slot boundary")
    end
  end

  def duration_matches_slot_duration
    if start_time.present? && end_time.present? && ((end_time - start_time) / 60) != slot_duration
      errors.add(:base, "appointment duration must be equal to the doctor's slot duration of #{slot_duration} minutes")
    end
  end

  def start_time_cannot_be_in_the_past
    if start_time.present? && start_time < current_time_in_timezone
      errors.add(:start_time, "can't be in the past")
    end
  end

  def end_time_cannot_be_in_the_past
    if end_time.present? && end_time < current_time_in_timezone
      errors.add(:end_time, "can't be in the past")
    end
  end
  
  def end_time_after_start_time
    if end_time.present? && start_time.present? && end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def slot_duration
    doctor.slot_duration_minutes
  end

  def current_time_in_timezone
    Time.current
  end
end
