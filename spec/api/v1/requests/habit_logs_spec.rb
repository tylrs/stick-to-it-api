require "rails_helper"

RSpec.describe "HabitLogs", type: :request do
  describe "Update" do
    before(:all) do
      @habit_log = create(:habit_log)
      @user = User.last
      @habit = Habit.last
      @habit_plan = HabitPlan.last
      @token = JsonWebTokenService.encode(user_id: @user.id)
    end

    it "Should be able to mark an incomplete habit log as completed" do
      headers = {"Content-type": "application/json", "Authorization": "Bearer #{@token}"}
      patch "/api/v1/users/#{@user.id}/habits/#{@habit.id}/habit_logs/#{@habit_log.id}", headers: headers

      updated_logs = HabitLog.where(habit_plan_id: @habit_plan.id)

      expect(updated_logs.last.completed_at).to eq "2022-02-02 00:00:00 UTC"
    end

    it "Should be able to mark a completed habit log as incomplete" do
      headers = {"Content-type": "application/json", "Authorization": "Bearer #{@token}"}
      patch "/api/v1/users/#{@user.id}/habits/#{@habit.id}/habit_logs/#{@habit_log.id}", headers: headers
      patch "/api/v1/users/#{@user.id}/habits/#{@habit.id}/habit_logs/#{@habit_log.id}", headers: headers

      updated_logs = HabitLog.where(habit_plan_id: @habit_plan.id)

      expect(updated_logs.last.completed_at).to eq nil
    end
  end
end
