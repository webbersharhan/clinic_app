class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.text :description

      t.timestamps
    end
    add_index :appointments, :start_time
    add_index :appointments, :end_time
    add_index :appointments, [:patient_id, :start_time, :end_time], name: 'index_appointments_on_patient_id_and_time_range'
  end
end
