class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_logs, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
