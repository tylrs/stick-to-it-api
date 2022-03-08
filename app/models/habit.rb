class Habit < ApplicationRecord
  belongs_to :creator, class_name: User
  has_many :habit_plans, dependent: :destroy
  has_many :users, through: :habit_plans

  validates :name, presence: true
  validates :description, presence: true
end
