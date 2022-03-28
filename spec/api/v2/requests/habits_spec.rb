require "rails_helper"

RSpec.describe "Habits v2", type: :request do
  describe "create habits" do
    before do
      @user = create(:user)
      token = JsonWebTokenService.encode(user_id: @user.id)
      @headers = {"Content-type": "application/json", "Authorization": "Bearer #{token}"}
    end

    it "should create a habit, habit plan, and habit logs until the current week's next Saturday if the end date is after or equal to next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/08"
      }

      post "/api/v2/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)
      created_habit = Habit.last
      created_habit_plan = HabitPlan.last
      habit_logs = HabitLog.where(habit_plan_id: created_habit_plan.id)
      
      expect(response.status).to eq 201
      
      expect(created_habit.name).to eq "Running"

      expect(created_habit_plan.user_id).to eq @user.id
      expect(created_habit_plan.habit_id).to eq created_habit.id
      expect(created_habit_plan.start_datetime).to eq "2022-02-02 00:00:00 UTC"
      expect(created_habit_plan.end_datetime).to eq "2022-02-08 00:00:00 UTC"

      expect(habit_logs.count).to eq 4
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-02 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-05 00:00:00 UTC"
    end

    it "should create a habit, habit plan, and habit logs until the end date if the end date is before the current week's next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/04"
      }

      post "/api/v2/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      created_habit = Habit.last
      created_habit_plan = HabitPlan.last
      habit_logs = HabitLog.where(habit_plan_id: created_habit_plan.id)
      
      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(created_habit_plan.user_id).to eq @user.id
      expect(created_habit_plan.habit_id).to eq created_habit.id
      expect(created_habit_plan.start_datetime).to eq "2022-02-02 00:00:00 UTC"
      expect(created_habit_plan.end_datetime).to eq "2022-02-04 00:00:00 UTC"
      expect(habit_logs.count).to eq 3
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-02 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-04 00:00:00 UTC"
    end

    it "should create a habit, habit plan, and no habit logs if the start date is after the current week's next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/13",
        end_datetime: "2022/02/20"
      }

      post "/api/v2/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      created_habit = Habit.last
      created_habit_plan = HabitPlan.last
      habit_logs = HabitLog.where(habit_plan_id: created_habit_plan.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(created_habit_plan.user_id).to eq @user.id
      expect(created_habit_plan.habit_id).to eq created_habit.id
      expect(created_habit_plan.start_datetime).to eq "2022-02-13 00:00:00 UTC"
      expect(created_habit_plan.end_datetime).to eq "2022-02-20 00:00:00 UTC"
      expect(habit_logs.count).to eq 0
    end

    it "should not be able to create a habit if there is missing information" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habitInfo = {
        name: "Running",
        description: "",
        start_datetime: "2022/02/13",
        end_datetime: "2022/02/20"
      }

      post "/api/v2/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      errors = JSON.parse(response.body)["errors"]
      
      expect(response.status).to eq 422
      expect(errors[0]).to eq "Description can't be blank"
    end
  end
end
