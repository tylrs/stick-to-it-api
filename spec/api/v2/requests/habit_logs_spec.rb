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

    context "when a habit log is incomplete to start" do
      it "responds with a success status" do
        expect(response).to be_ok
      end

      it "responds with an updated habit log" do
        expect(json["habit_log"]["completed_at"]).not_to be_empty
      end
    end

    context "when a habit log is marked completed to start" do
      before do
        patch "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}", headers: headers
      end

      it "responds with a success status" do
        expect(response.status).to eq 200
      end

      it "marks a completed habit log as incomplete" do
        expect(json["habit_log"]["completed_at"]).to be_nil
      end
    end
  end
end
