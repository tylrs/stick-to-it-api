require "rails_helper"

RSpec.describe "HabitPlans v2", type: :request do
  let(:habit_log) { create(:habit_log) }
  let(:user) { habit_log.habit_plan.user }
  let(:token) { JsonWebTokenService.encode(user_id: user.id) }
  let(:headers) { {"Content-type": "application/json", "Authorization": "Bearer #{token}"} }
  let(:habit_plan) { habit_log.habit_plan }
  let(:habit) { habit_plan.habit }
  
  before do
    FactoryBot.create_list(:habit_log, 3, habit_plan_id: habit_plan.id) do |habit_log, i|
      date = Date.new(2022,2,3)
      date += i.days
      habit_log.scheduled_at = date
      habit_log.save
    end
  end

  describe "#show_week" do
    it_behaves_like "a protected route" do
      let(:request_type) { :get }
      let(:path) { "/api/v2/users/#{user.id}/habit_plans/week" }
    end

    context "when a user has one habit plan for this week" do
      let(:habit_plan_details) { parsed_response[0] }

      before do
        allow(Date).to receive(:today).and_return Date.new(2022,2,1)

        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers
      end

      it "responds with a success status" do
        expect(response).to be_ok
      end

      describe "return value" do
        it "includes one habit plan" do
          expect(parsed_response.length).to eq 1
        end
  
        it "includes habit plan info" do
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
            updated_at]

          expect(habit_plan_details.keys).to match_array(habit_plan_info_keys)
        end
  
        it "includes habit info" do
          habit_info_keys = %w[name description creator_id] 
  
          expect(habit_plan_details["habit"].keys).to match_array(habit_info_keys)
        end
  
        it "includes the correct number of habit_logs for this week" do
          expect(habit_plan_details["habit_logs"].length).to eq 4  
        end
      end

    end

    context "when a user has multiple habit plans for this week" do
      let(:habit_plan_2) { create(:habit_plan, {start_datetime: "2022-02-05 00:00:00", user: user}) }
      let!(:habit_log_2) { create(:habit_log, {scheduled_at: "2022/02/05", habit_plan: habit_plan_2}) }
      
      before do
        allow(Date).to receive(:today).and_return Date.new(2022,2,1)

        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers
      end
      
      it "returns multiple habit plans" do
        expect(parsed_response.length).to eq 2
      end

      it "returns the correct habit plans" do
        expect(parsed_response).to include(
          include("id" => habit_plan.id),
          include("id" => habit_plan_2.id)
        )
      end
    end

    context "when a user does not have any habit plans for the current week" do
      let(:user) { create(:user) }

      it "does not return habit plans for this week" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,11)
        
        get "/api/v2/users/#{user.id}/habit_plans/week", headers: headers

        expect(parsed_response.length).to eq 0
      end
    end
  end

  describe "#show_today" do
    it_behaves_like "a protected route" do
      let(:request_type) { :get }
      let(:path) { "/api/v2/users/#{user.id}/habit_plans/today" }
    end

    context "when a user has a habit plan for today" do
      let(:habit_plan_details) { parsed_response[0] }

      before do
        allow(Date).to receive(:today).and_return Date.new(2022,2,3)

        get "/api/v2/users/#{user.id}/habit_plans/today", headers: headers
      end

      it "responds with a success status" do
        expect(response).to be_ok
      end

      describe "return value" do
        it "includes habit plan info" do
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
            updated_at]
            
          expect(habit_plan_details.keys).to match_array(habit_plan_info_keys)
        end
  
        it "includes habit info" do
          habit_info_keys = %w[name description creator_id] 
  
          expect(habit_plan_details["habit"].keys).to match_array(habit_info_keys)
        end
  
        it "includes one habit log per habit plan" do
          expect(habit_plan_details["habit_logs"].length).to eq 1
        end
      end
    end

    context "when a user does not have any habit plans for today" do
      it "does not return habit plans for today" do
        allow(Date).to receive(:today).and_return Date.new(2022,2,11)
        
        get "/api/v2/users/#{user.id}/habit_plans/today", headers: headers

        expect(parsed_response.length).to eq 0
      end
    end
  end

  describe "#destroy" do
    it_behaves_like "a protected route" do
      let(:request_type) { :delete }
      let(:path) { "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}" }
    end

    before do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
    end

    it "returns a success status" do
      delete "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}", headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it "does not destroy a habit" do
      expect {
        delete "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}", 
        headers: headers
      }.to_not change { Habit.count }
    end

    it "destroys a habit plan" do
      expect {
        delete "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}", 
        headers: headers
      }.to change { HabitPlan.count }.by(-1)
    end

    it "destroys associated habit logs" do
      expect {
        delete "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}", 
        headers: headers
      }.to change { HabitLog.count }.by(-4)
    end
  end
end
