require "rails_helper"

RSpec.describe "Habits", type: :request do
  describe "Create" do
    before(:all) do
      @user = create(:user)
      token = JsonWebTokenService.encode(user_id: @user.id)
      @headers = {"Content-type": "application/json", "Authorization": "Bearer #{token}"}
    end

    it "Should create a habit and habit logs until the current week's next Saturday if the end date is after or equal to next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/08"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info)

      created_habit = Habit.last
      habit_plan = HabitPlan.last
      habit_logs = HabitLog.where(habit_plan_id: habit_plan.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 4
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-02 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-05 00:00:00 UTC"
    end

    it "Should create a habit and habit logs until the end date if the end date is before the current week's next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/04"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info)

      created_habit = Habit.last
      habit_plan = HabitPlan.last
      habit_logs = HabitLog.where(habit_plan_id: habit_plan.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 3
      expect(habit_logs.first.scheduled_at.to_s).to eq "2022-02-02 00:00:00 UTC"
      expect(habit_logs.last.scheduled_at.to_s).to eq "2022-02-04 00:00:00 UTC"
    end

    it "Should create a habit and no habit logs if the start date is after the current week's next Saturday" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/13",
        end_datetime: "2022/02/20"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info)

      created_habit = Habit.last
      habit_plan = HabitPlan.last
      habit_logs = HabitLog.where(habit_plan_id: habit_plan.id)

      expect(response.status).to eq 201
      expect(created_habit.name).to eq "Running"
      expect(habit_logs.count).to eq 0
    end

    it "Should return habit info and the current week's habit logs" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/05"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info)

      get "/api/v1/users/#{@user.id}/habits", headers: @headers
      habit_response = JSON.parse(response.body)[0]
      
      expect(response.status).to eq 200
      expect(habit_response["user_id"]).to eq @user.id
      expect(habit_response["name"]).to eq habit_info[:name]
      expect(habit_response["habit_logs"].length).to eq 4
      expect(habit_response["habit_logs"][0]["scheduled_at"]).to eq "2022-02-02T00:00:00.000Z"
      expect(habit_response["habit_logs"][3]["scheduled_at"]).to eq "2022-02-05T00:00:00.000Z"
    end

    it "Should return no habit info and no habit logs if there are no habit logs for the current week" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/07",
        end_datetime: "2022/02/10"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info)

      get "/api/v1/users/#{@user.id}/habits", headers: @headers
      habit_response = JSON.parse(response.body)[0]

      expect(response.status).to eq 200
      expect(habit_response).to eq nil
    end

    it "Should return habits for today and associated habit logs" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info1 = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/01",
        end_datetime: "2022/02/05"
      }
      habit_info2 = {
        name: "Meditation",
        description: "Every morning",
        start_datetime: "2022/02/06",
        end_datetime: "2022/02/09"
      }
      habit_info3 = {
        name: "Eat Healthy",
        description: "Every morning",
        start_datetime: "2022/02/01",
        end_datetime: "2022/02/09"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info1)
      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info2)
      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info3)

      get "/api/v1/users/#{@user.id}/habits/today", headers: @headers
      habitsResponse = JSON.parse(response.body)
      
      expect(response.status).to eq 200
      expect(habitsResponse.length).to eq 2
      expect(habitsResponse[0]["user_id"]).to eq @user.id
      expect(habitsResponse[0]["name"]).to eq habit_info1[:name]
      expect(habitsResponse[0]["habit_logs"].length).to eq 1
      expect(habitsResponse[0]["habit_logs"][0]["scheduled_at"]).to eq "2022-02-01T00:00:00.000Z"
    end

    it "Should be able to delete a habit and associated habit logs" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
      habit_info1 = {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/05"
      }
      habit_info2 = {
        name: "Meditation",
        description: "Every morning",
        start_datetime: "2022/02/03",
        end_datetime: "2022/02/05"
      }

      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info1)
      post "/api/v1/users/#{@user.id}/habits", headers: @headers, params: JSON.generate(habit_info2)

      habit1 = Habit.find_by name: "Running"
      habit2 = Habit.find_by name: "Meditation"
      delete "/api/v1/users/#{@user.id}/habits/#{habit1.id}", headers: @headers

      expect(response.status).to eq 204
      expect(Habit.all.length).to eq 1
      expect(Habit.find_by name: "Running").to eq nil
      expect(HabitLog.find_by habit_id: habit1.id).to eq nil
      expect(HabitLog.where(habit_id: habit2.id).length).to eq 3
    end
  end
end
