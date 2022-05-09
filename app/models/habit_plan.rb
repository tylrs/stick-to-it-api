class HabitPlan < ApplicationRecord
  belongs_to :user
  belongs_to :habit
  has_many :habit_logs, dependent: :destroy
  has_one :invitation, dependent: :destroy

  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
   
  scope :with_current_week_logs, lambda { 
    includes(:habit_logs)
      .where(habit_logs: { scheduled_at: Date.today.beginning_of_week(:sunday)..Date.today.end_of_week(:sunday) }) 
  }
end
