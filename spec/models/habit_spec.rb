require "rails_helper"

RSpec.describe Habit, type: :model do
  describe "relationships" do
    it { is_expected.to have_many(:habit_plans) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to belong_to(:creator) }
  end
  
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
