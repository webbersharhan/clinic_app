module Api
  module V1
    module Patients
      class PatientsController < ApplicationController
        before_action :set_patient, only: [:show, :update, :destroy]
    
        # GET /api/v1/patients/:id
        def show
          render json: @patient
        end
    
        # POST /api/v1/patients
        def create
          @patient = Patient.new(patient_params)
    
          if @patient.save
            render json: @patient, status: :created
          else
            render json: @patient.errors, status: :unprocessable_entity
          end
        end
    
        # PUT/PATCH /api/v1/patients/:id
        def update
          if @patient.update(patient_params)
            render json: @patient
          else
            render json: @patient.errors, status: :unprocessable_entity
          end
        end
    
        # DELETE /api/v1/patients/:id
        def destroy
          @patient.destroy
          head :no_content
        end
    
        private
    
        def set_patient
          @patient = Patient.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Patient not found" }, status: :not_found
        end
    
        def patient_params
          params.require(:patient).permit(:first_name, :last_name, :email)
        end
        
      end
    end
  end
end
