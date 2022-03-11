require "rails_helper"

RSpec.describe "HabitPlans", type: :request do
  describe "Get HabitPlans" do
    before(:all) do
      @habit_log = create(:habit_log)
      @user = User.last
      @habit_plan = HabitPlan.last
      @token = JsonWebTokenService.encode(user_id: @user.id)
      FactoryBot.create_list(:habit_log, 3, habit_plan_id: @habit_plan.id) do |habit_log, i|
        date = Date.new(2022,2,3)
        date += i.days
        habit_log.scheduled_at = date
        habit_log.save
      end
      debugger
    end

    it "Should return HabitPlans for this week" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      
    end

    it "Should return HabitPlans for today" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      
    end
  end
end
