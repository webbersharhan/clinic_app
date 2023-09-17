class Patient < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true

  has_many :appointments
  has_many :doctors, through: :appointments
end
