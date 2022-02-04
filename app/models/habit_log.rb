class HabitLog < ApplicationRecord
    belongs_to :habit
    has_one :user, :through => :habit
end
