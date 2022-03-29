require "rails_helper"

RSpec.describe HabitLogsCreationService do
  let(:user) {create(:user)}
  let(:habit_plan) {create(:habit_plan, {user: user})}
  params = ActionController::Parameters.new({
    name: "Running", 
    description: "Run every day",
    user_id: 1,
    start_datetime: "2022/02/02",
    end_datetime: "2022/02/10"  
    })
  date1 = Date.new(2022,02,02)

  describe "get_num_logs" do
    it "returns number of days between and including 2 dates" do
      date_limit = Date.new(2022,02,12)
      num_logs = HabitLogsCreationService.get_num_logs(date1, date_limit)

      expect(num_logs).to eq(11)
    end
  end

  describe "create_logs" do
    before do
      HabitLogsCreationService.create_logs(3, date1, habit_plan)
      @logs = HabitLog.all
    end

    it "creates a fixed number of habit logs starting at a specified date" do
      expect(@logs.count).to eq(3)
    end

    it "creates a habit log with the start date" do
      expect(@logs.first.scheduled_at).to eq(date1)
    end

    it "schedules a habit log for 3 days past the date limit" do
      expect(@logs.last.scheduled_at).to eq(date1 + 2.days)
    end
  end
end