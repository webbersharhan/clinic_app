class CreateDoctorAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :doctor_availabilities do |t|
      t.references :doctor, null: false, foreign_key: true
      t.date :date, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
