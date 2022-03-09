require "rails_helper"

RSpec.describe HabitLog, type: :model do
  describe "Relationships" do
    it { should belong_to(:habit_plan) }
    it { should have_one(:user) }
    it { should have_one(:habit) }
  end

  describe "Validations" do
    it { should validate_presence_of(:scheduled_at) }
  end
end
