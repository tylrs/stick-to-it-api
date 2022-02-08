require 'rails_helper'

RSpec.describe "HabitLogs", type: :request do
  describe "GET /update" do
    it "returns http success" do
      get "/habit_logs/update"
      expect(response).to have_http_status(:success)
    end
  end

end
