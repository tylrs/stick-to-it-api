require "rails_helper"

RSpec.describe "HabitLogs v2", type: :request do
  describe "update habit logs" do
    let(:habit_log) {create(:habit_log)}
    let(:habit_plan) {habit_log.habit_plan}
    let(:user) {habit_log.habit_plan.user}
    let(:token) {JsonWebTokenService.encode(user_id: user.id)}
    let(:headers) {{"Content-type": "application/json", "Authorization": "Bearer #{token}"}}

    before do
      patch "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}", headers: headers
    end

    it "should be able to mark an incomplete habit log as completed" do
      updated_logs = HabitLog.where(habit_plan_id: habit_plan.id)

      expect(updated_logs.last.completed_at).to eq "2022-02-02 00:00:00 UTC"
    end

    it "should be able to mark a completed habit log as incomplete" do
      patch "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/habit_logs/#{habit_log.id}", headers: headers

      updated_logs = HabitLog.where(habit_plan_id: habit_plan.id)

      expect(updated_logs.last.completed_at).to eq nil
    end
  end
end
