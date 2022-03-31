require "rails_helper"

RSpec.describe "HabitPlans v2", type: :request do
  let(:habit_log) {create(:habit_log)}
  let(:user) {habit_log.habit_plan.user}
  let(:token) {token = JsonWebTokenService.encode(user_id: user.id)}
  let(:headers) {{"Content-type": "application/json", "Authorization": "Bearer #{token}"}}
  let(:habit_plan) {habit_log.habit_plan}
  
  before do
    FactoryBot.create_list(:habit_log, 3, habit_plan_id: habit_plan.id) do |habit_log, i|
      date = Date.new(2022,2,3)
      date += i.days
      habit_log.scheduled_at = date
      habit_log.save
    end
  end

  describe ".show_week" do
    context "when a user has one habit plan for this week" do
      let(:habit_plan_details) {json[0]}

      before do
        allow(Date).to receive(:today).and_return Date.new(2022,2,1)
        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers
      end

      it "should respond with a success status" do
        expect(response.status).to eq 200
      end

      it "should return one habit plan" do
        expect(json.length).to eq 1
      end

      it "should return habit_plan_info" do
        expect(habit_plan_details.symbolize_keys).to include(
          id: habit_plan.id,
          user_id: user.id,
          habit_id: habit_plan.habit_id,
          start_datetime: "2022-02-02T00:00:00.000Z",
          end_datetime: "2022-02-10T00:00:00.000Z" 
        ) 
      end

      it "should return habit_info" do
        expect(habit_plan_details["habit"].symbolize_keys).to include(
          name: "Running",
          description: "Run every day"
        ) 
      end

      it "should return habit_logs for this week" do
        expect(habit_plan_details["habit_logs"].length).to eq 4  
      end
    end

    context "when a user has multiple habit plans for this week" do
      pending
    end

    context "when a user does not have any habit plans for the current week" do
      pending
      it "should not return habit plans for this week if there are none scheduled" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,11)
        
        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers
  
        habits = JSON.parse(response.body)
        habit1 = habits[0]
        
        expect(response.status).to eq 200
        expect(habits.length).to eq 0
      end
    end
  end

  describe ".show_today" do
    pending
    context "when a user has a habit plan for today" do
      it "should return habit plans for today" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,3)
  
        get "/api/v2/users/#{user.id}/habit_plans/today", headers: headers
  
        habits = JSON.parse(response.body)
        habit1 = habits[0]
        
        expect(response.status).to eq 200
        expect(habits.length).to eq 1
        expect(habit1["id"]).to eq habit_plan.id
        expect(habit1["user_id"]).to eq user.id
        expect(habit1["habit_id"]).to eq habit_plan.habit_id
        expect(habit1["habit"]["name"]).to eq "Running"
        expect(habit1["habit"]["description"]).to eq "Run every day"
        expect(habit1["start_datetime"].to_s).to eq "2022-02-02T00:00:00.000Z"
        expect(habit1["end_datetime"].to_s).to eq "2022-02-10T00:00:00.000Z"
        expect(habit1["habit_logs"].length).to eq 1   
      end
    end

    context "when a user does not have any habit plans for today" do
      it "should not return habit plans for today if there are none scheduled" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,11)
        
        get "/api/v2/users/#{user.id}/habit_plans/today", headers: headers
  
        habits = JSON.parse(response.body)
        habit1 = habits[0]
        
        expect(response.status).to eq 200
        expect(habits.length).to eq 0
      end
    end
  end

  describe ".destroy" do
    pending
    it "should be able to delete a habit plan and associated habit logs" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)

      delete "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}", headers: headers

      expect(response.status).to eq 204
      expect(Habit.all.length).to eq 1
      expect(HabitPlan.all.length).to eq 0
      expect(HabitLog.find_by habit_plan_id: habit_plan.id).to eq nil
    end
  end
end
