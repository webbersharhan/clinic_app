require 'rails_helper'

RSpec.describe "Api::V1::Patients::Patients", type: :request do
  let!(:patient) { create(:patient) }
  let(:valid_attributes) { { first_name: "John", last_name: "Doe", email: "john.doe@example.com" } }
  let(:invalid_attributes) { { first_name: "", last_name: "", email: "" } }

  describe "GET /show" do
    it "returns a specific patient" do
      get api_v1_patient_path(patient)
      expect(response).to be_successful
      expect(JSON.parse(response.body)["id"]).to eq(patient.id)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Patient" do
        expect {
          post api_v1_patients_path, params: { patient: valid_attributes }
        }.to change(Patient, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Patient and returns an error" do
        expect {
          post api_v1_patients_path, params: { patient: invalid_attributes }
        }.to change(Patient, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /update" do
    context "with valid parameters" do
      let(:updated_attributes) { { first_name: "Jane", last_name: "Smith" } }

      it "updates the requested patient" do
        put api_v1_patient_path(patient), params: { patient: updated_attributes }
        patient.reload
        expect(patient.first_name).to eq(updated_attributes[:first_name])
        expect(patient.last_name).to eq(updated_attributes[:last_name])
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not update the patient and returns an error" do
        put api_v1_patient_path(patient), params: { patient: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes the requested patient" do
      expect {
        delete api_v1_patient_path(patient)
      }.to change(Patient, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
