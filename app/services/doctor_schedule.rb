class DoctorSchedule
  attr_reader :doctor, :date
  
  def initialize(doctor, date)
    @doctor = doctor
    @date = date
  end

  def available_slots
    return [] unless availabilities
    all_slots = []

    availabilities.each do |availability|
      all_slots.concat(
        generate_slots(availability.start_time, availability.end_time, doctor.slot_duration_minutes)
        .reject { |slot| overlaps_with_booked_slots?(slot, booked_slots) } 
      )
    end 

    all_slots
  end

  private

  def availabilities
    DoctorAvailability.where(doctor: doctor, date: date)
  end

  def generate_slots(start_time, end_time, duration)
    slots = []
    slot_start = start_time

    while slot_start + duration.minutes <= end_time
      slots << [format_time(slot_start), format_time(slot_start + duration.minutes)]
      slot_start += duration.minutes
    end

    slots
  end

  def format_time(time)
    time.strftime('%H:%M:%S')
  end

  def overlaps_with_booked_slots?(slot, booked_slots)
    booked_slots.any? do |booked|
      (slot[0]...slot[1]).overlaps?(booked[0]...booked[1])
    end
  end

  def appointments
    @appointments ||= Appointment.where(doctor: doctor, start_time: date.beginning_of_day..date.end_of_day)
  end

  def booked_slots
    appointments.map { |a| [format_time(a.start_time), format_time(a.end_time)] }
  end
end
