require "rails_helper"

RSpec.describe User, type: :model do

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password(:password) }
  end

  describe "relationships" do
    it { should have_many(:habits) }
    it { should have_many(:habit_plans) }
    it { should have_many(:habit_logs) }
    it { should have_many(:created_habits) }
  end

end
