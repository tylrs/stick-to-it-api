class User < ApplicationRecord
  has_secure_password
  has_many :habits
  has_many :habit_plans
  has_many :habit_logs, through: :habit_plans

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
