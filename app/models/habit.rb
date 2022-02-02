class Habit < ApplicationRecord
    belongs_to :user

    validates :name, presence: true
    validates :description, presence: true
    validates :start_datetime, presence: true
end
