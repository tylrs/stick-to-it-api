require "rails_helper"

RSpec.describe "HabitLogs v2", type: :request do
  describe "#update" do
    let(:habit_log) { create(:habit_log) }
    let(:habit_plan) { habit_log.habit_plan }
    let(:user) { habit_log.habit_plan.user }
    let(:token) { JsonWebTokenService.encode(user_id: user.id) }
    let(:headers) { {"Content-type": "application/json", "Authorization": "Bearer #{token}"} }

    before do
      patch "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}", headers: headers
    end

    it_behaves_like "a protected route" do
      let(:request_type) { :patch }
      let(:path) { "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}" }
    end

    context "when a habit log is incomplete to start" do
      it "responds with a success status" do
        expect(response).to be_ok
      end

      it "responds with an updated habit log" do
        expect(parsed_response["habit_log"]["completed_at"]).not_to be_empty
      end
    end

    context "when a habit log is marked completed to start" do
      before do
        patch "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}", headers: headers
      end

      it "responds with a success status" do
        expect(response).to be_ok
      end

      it "marks a completed habit log as incomplete" do
        expect(parsed_response["habit_log"]["completed_at"]).to be_nil
      end
    end

    context "when a habit log cannot be found" do
      before do
        HabitLog.destroy_all
        patch "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}", headers: headers
      end

      it "responds with an error status" do
        expect(response).to have_http_status(:not_found)
      end

      it "responds with an error message" do
        expect(parsed_response["errors"]).to eq "Habit Log Not Found"
      end
    end
  end
end
