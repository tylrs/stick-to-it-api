class HabitPlan < ApplicationRecord
  belongs_to :user
  belongs_to :habit
  has_many :habit_logs, dependent: :destroy

  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
   
  scope :current_week, lambda {where("start_datetime <= ? AND end_datetime >= ?", 
                                          Date.today.next_occurring(:saturday), 
                                          Date.today.beginning_of_week(:sunday))}
end
