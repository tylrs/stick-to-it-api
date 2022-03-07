require "rails_helper"

RSpec.describe "Habits", type: :request do
  describe "Create" do
    before(:all) do
      @user = create(:user)
      token = JsonWebTokenService.encode(user_id: @user.id)
      @headers = {"Content-type": "application/json", "Authorization": "Bearer #{token}"}
    end

    it "Should create a habit and habit logs until the current week's next Saturday if the end date is after or equal to next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,10)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/10",
        end_datetime: "2022/02/15"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      created_habit = Habit.last
      habit_logs = HabitLog.where(habit_id: created_habit.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 3
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-10 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-12 00:00:00 UTC"
    end

    it "Should create a habit and habit logs until the end date if the end date is before the current week's next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,10)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/10",
        end_datetime: "2022/02/11"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      created_habit = Habit.last
      habit_logs = HabitLog.where(habit_id: created_habit.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 2
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-10 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-11 00:00:00 UTC"
    end

    it "Should create a habit and no habit logs if the start date is after the current week's next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,10)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/13",
        end_datetime: "2022/02/20"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      created_habit = Habit.last
      habit_logs = HabitLog.where(habit_id: created_habit.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 0
    end

    it "Should return habit info and the current week's habit logs" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,3)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/03",
        end_datetime: "2022/02/05"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      get "/users/#{@user.id}/habits", headers: @headers
      habitResponse = JSON.parse(response.body)[0]
      
      expect(response.status).to eq 200
      expect(habitResponse["user_id"]).to eq @user.id
      expect(habitResponse["name"]).to eq habitInfo[:name]
      expect(habitResponse["habit_logs"].length).to eq 3
      expect(habitResponse["habit_logs"][0]["scheduled_at"]).to eq "2022-02-03T00:00:00.000Z"
      expect(habitResponse["habit_logs"][2]["scheduled_at"]).to eq "2022-02-05T00:00:00.000Z"
    end

    it "Should return no habit info and no habit logs if there are no habit logs for the current week" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,3)
      habitInfo = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/07",
        end_datetime: "2022/02/10"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo)

      get "/users/#{@user.id}/habits", headers: @headers
      habitResponse = JSON.parse(response.body)[0]

      expect(response.status).to eq 200
      expect(habitResponse).to eq nil
    end

    it "Should return habits for today and associated habit log" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,3)
      habitInfo1 = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/03",
        end_datetime: "2022/02/05"
      }
      habitInfo2 = {
        name: "Meditation",
        description: "Every morning",
        start_datetime: "2022/02/06",
        end_datetime: "2022/02/09"
      }
      habitInfo3 = {
        name: "Eat Healthy",
        description: "Every morning",
        start_datetime: "2022/02/03",
        end_datetime: "2022/02/09"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo1)
      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo2)
      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo3)

      get "/users/#{@user.id}/habits/today", headers: @headers
      habitsResponse = JSON.parse(response.body)
      
      expect(response.status).to eq 200
      expect(habitsResponse.length).to eq 2
      expect(habitsResponse[0]["user_id"]).to eq @user.id
      expect(habitsResponse[0]["name"]).to eq habitInfo1[:name]
      expect(habitsResponse[0]["habit_logs"].length).to eq 1
      expect(habitsResponse[0]["habit_logs"][0]["scheduled_at"]).to eq "2022-02-03T00:00:00.000Z"
    end

    it "Should be able to delete a habit and associated habit logs" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,3)
      habitInfo1 = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/03",
        end_datetime: "2022/02/05"
      }
      habitInfo2 = {
        name: "Meditation",
        description: "Every morning",
        start_datetime: "2022/02/03",
        end_datetime: "2022/02/05"
      }

      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo1)
      post "/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habitInfo2)

      habit1 = Habit.find_by name: "Running"
      habit2 = Habit.find_by name: "Meditation"
      delete "/users/#{@user.id}/habits/#{habit1.id}", headers: @headers

      expect(response.status).to eq 204
      expect(Habit.all.length).to eq 1
      expect(Habit.find_by name: "Running").to eq nil
      expect(HabitLog.find_by habit_id: habit1.id).to eq nil
      expect(HabitLog.where(habit_id: habit2.id).length).to eq 3
    end
  end
end
