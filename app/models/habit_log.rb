class HabitLog < ApplicationRecord
  belongs_to :habit_plan
  has_one :user, through: :habit_plan
  has_one :habit, through: :habit_plan

  validates :scheduled_at, presence: true
end
