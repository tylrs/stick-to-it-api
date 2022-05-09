require "rails_helper"

RSpec.describe HabitLog, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:habit_plan) }
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_one(:habit) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:scheduled_at) }
  end
end
