module Api
  module V1
    module Doctors
      class DoctorAvailabilitiesController < ApplicationController
        before_action :set_doctor
        before_action :set_availability, only: [:show, :update, :destroy]

        # GET /api/v1/doctors/:doctor_id/availabilities
        def index
          @availabilities = @doctor.availabilities
          render json: @availabilities
        end

        # GET /api/v1/doctors/:doctor_id/availabilities/:id
        def show
          render json: @availability
        end

        # POST /api/v1/doctors/:doctor_id/availabilities
        def create
          @availability = @doctor.availabilities.new(availability_params)

          if @availability.save
            render json: @availability, status: :created
          else
            render json: @availability.errors, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/doctors/:doctor_id/availabilities/:id
        def update
          if @availability.update(availability_params)
            render json: @availability
          else
            render json: @availability.errors, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/doctors/:doctor_id/availabilities/:id
        def destroy
          @availability.destroy
          head :no_content
        end

        private

        def set_doctor
          @doctor = Doctor.find(params[:doctor_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Doctor not found" }, status: :not_found
        end

        def set_availability
          @availability = @doctor.availabilities.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Availability not found" }, status: :not_found
        end

        def availability_params
          params.require(:availability).permit(:start_time, :end_time, :date)
        end
      end
    end
  end
end
