require "rails_helper"

RSpec.describe HabitPlan, type: :model do
  describe "Relationships" do
    it { should belong_to(:user) }
    it { should belong_to(:habit) }
    it { should have_many(:habit_logs) }
  end

  describe "Validations" do
    it { should validate_presence_of(:start_datetime) }
    it { should validate_presence_of(:end_datetime) }
  end
end
