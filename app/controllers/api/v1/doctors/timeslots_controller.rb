module Api
  module V1
    module Doctors
      class TimeslotsController < ApplicationController
        before_action :set_doctor

        # GET /api/v1/doctors/:doctor_id/timeslots
        def index
          date = params[:date].present? ? safe_date_parse(params[:date]) : Time.zone.today
          @timeslots = DoctorSchedule.new(@doctor, date).available_slots
          
          render json: @timeslots
        end

        private

        def set_doctor
          @doctor = Doctor.find(params[:doctor_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Doctor not found" }, status: :not_found
        end

        def safe_date_parse(date_str)
          Time.zone.parse(date_str)
        rescue ArgumentError
          render json: { error: "Invalid date format" }, status: :unprocessable_entity
          nil
        end
      end
    end
  end
end