require "rails_helper"

RSpec.describe "HabitLogs", type: :request do
  describe "Update" do
    before(:all) do
      @habit_log = create(:habit_log)
      @user = User.last
      @habit = Habit.last
    end

    it "Should be able to mark an incomplete habit log as completed" do
      token = JsonWebTokenService.encode(user_id: @user.id)
      headers = {"Content-type": "application/json", "Authorization": "Bearer #{token}"}
      patch "/users/#{@user.id}/habits/#{@habit.id}/habit_logs/#{@habit_log.id}", headers: headers

      updated_logs = HabitLog.where(habit_id: @habit.id)

      expect(updated_logs.last.completed_at).to eq "2022-02-02 00:00:00 UTC"
    end

    it "Should be able to mark a completed habit log as incomplete" do
      token = JsonWebTokenService.encode(user_id: @user.id)
      headers = {"Content-type": "application/json", "Authorization": "Bearer #{token}"}
      patch "/users/#{@user.id}/habits/#{@habit.id}/habit_logs/#{@habit_log.id}", headers: headers
      patch "/users/#{@user.id}/habits/#{@habit.id}/habit_logs/#{@habit_log.id}", headers: headers

      updated_logs = HabitLog.where(habit_id: @habit.id)

      expect(updated_logs.last.completed_at).to eq nil
    end
  end
end
