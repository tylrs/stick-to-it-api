require "rails_helper"

RSpec.describe "Habits", type: :request do
  describe "Create" do
    before(:all) do
      @user = create(:user)
    end

    it "Should create a habit and only current week's habit logs until next Saturday if the end date is after next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,10)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/10",
        end_datetime: "2022/02/15"
      }
      token = JsonWebTokenService.encode(user_id: @user.id)
      headers = {"Content-type": "application/json", "Authorization": "Bearer #{token}"}
      
      post "/users/#{@user.id}/habits", headers: headers, params: JSON.generate(habitInfo)

      created_habit = Habit.last
      habit_logs = HabitLog.where(habit_id: created_habit.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 6
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-10 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-15 00:00:00 UTC"
    end
  end
end
