class Habit < ApplicationRecord
    has_many :user_habits
    has_many :users, through: :user_habits

    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    validates :start_datetime, presence: true
end
