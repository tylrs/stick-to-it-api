class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_logs

  validates :name, presence: true
  validates :description, presence: true
  validates :start_datetime, presence: true
end
