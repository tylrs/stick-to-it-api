require "rails_helper"

RSpec.describe "HabitPlans v2", type: :request do
  let(:habit_log) {create(:habit_log)}
  let(:user) {habit_log.habit_plan.user}
  let(:token) {token = JsonWebTokenService.encode(user_id: user.id)}
  let(:headers) {{"Content-type": "application/json", "Authorization": "Bearer #{token}"}}
  let(:habit_plan) {habit_log.habit_plan}
  let(:habit) {habit_plan.habit}
  
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

      it "should return habit plan info" do
        habit_plan_info_keys = %w[
          id
          user_id
          user
          habit_id
          habit
          start_datetime
          end_datetime
          habit_logs
          created_at
          updated_at
        ]
        expect(habit_plan_details.keys).to match_array(habit_plan_info_keys)
      end

      it "should return habit info" do
        habit_info_keys = %w[name description creator_id] 

        expect(habit_plan_details["habit"].keys).to match_array(habit_info_keys)
      end

      it "should return habit_logs for this week" do
        expect(habit_plan_details["habit_logs"].length).to eq 4  
      end
    end

    context "when a user has multiple habit plans for this week" do
      let(:habit_plan_2) {create(:habit_plan, {start_datetime: "2022-02-05 00:00:00", user: user})}
      before do
        allow(Date).to receive(:today).and_return Date.new(2022,2,1)
        create(:habit_log, {scheduled_at: "2022/02/05", habit_plan: habit_plan_2})
        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers
      end
      
      it "should return multiple habit plans" do
        expect(json.length).to eq 2
      end
    end

    context "when a user does not have any habit plans for the current week" do
      let(:user) {create(:user)}

      it "should not return habit plans for this week" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,11)
        
        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers

        expect(json.length).to eq 0
      end
    end
  end

  describe ".show_today" do
    context "when a user has a habit plan for today" do
      let(:habit_plan_details) {json[0]}

      before do
        allow(Date).to receive(:today).and_return Date.new(2022,2,3)

        get "/api/v2/users/#{user.id}/habit_plans/today", headers: headers
      end

      it "should respond with a success status" do
        expect(response.status).to eq 200
      end

      it "should return habit plan info" do
        habit_plan_info_keys = %w[
          id
          user_id
          user
          habit_id
          habit
          start_datetime
          end_datetime
          habit_logs
          created_at
          updated_at
        ]
        expect(habit_plan_details.keys).to match_array(habit_plan_info_keys)
      end

      it "should return habit info" do
        habit_info_keys = %w[name description creator_id] 

        expect(habit_plan_details["habit"].keys).to match_array(habit_info_keys)
      end

      it "should return one habit log per habit plan" do
        expect(habit_plan_details["habit_logs"].length).to eq(1)
      end
    end

    context "when a user does not have any habit plans for today" do
      it "should not return habit plans for today" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,11)
        
        get "/api/v2/users/#{user.id}/habit_plans/today", headers: headers

        expect(json.length).to eq 0
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
