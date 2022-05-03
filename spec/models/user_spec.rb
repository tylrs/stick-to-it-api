require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to have_secure_password(:password) }
  end

  describe "relationships" do
    it { is_expected.to have_many(:habits) }
    it { is_expected.to have_many(:habit_plans) }
    it { is_expected.to have_many(:habit_logs) }
    it { is_expected.to have_many(:created_habits) }
  end
end
