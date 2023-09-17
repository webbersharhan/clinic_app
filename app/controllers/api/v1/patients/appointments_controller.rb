module Api
  module V1
    module Patients
      class AppointmentsController < ApplicationController
        before_action :set_patient
        before_action :set_appointment, only: [:show, :update, :destroy]
  
        # GET /api/v1/patients/:patient_id/appointments
        def index
          @appointments = @patient.appointments
          render json: @appointments
        end
  
        # GET /api/v1/patients/:patient_id/appointments/:id
        def show
          render json: @appointment
        end

        # POST /api/v1/patients/:patient_id/appointments
        def create
          @appointment = @patient.appointments.new(appointment_params)
          if @appointment.save
            render json: @appointment, status: :created
          else
            render json: @appointment.errors, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/patients/:patient_id/appointments/:id
        def update
          if @appointment.update(appointment_params)
            render json: @appointment
          else
            render json: @appointment.errors, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/patients/:patient_id/appointments/:id
        def destroy
          @appointment.destroy
          head :no_content
        end
  
        private
  
        def set_patient
          @patient = Patient.find(params[:patient_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Patient not found" }, status: :not_found
        end
  
        def set_appointment
          @appointment = @patient.appointments.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Appointment not found" }, status: :not_found
        end
  
        def appointment_params
          params.require(:appointment).permit(:doctor_id, :start_time, :end_time, :description)
        end
      end
    end
  end
end
