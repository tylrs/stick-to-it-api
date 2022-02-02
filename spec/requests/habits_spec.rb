require 'rails_helper'

RSpec.describe "Habits", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/habits/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/habits/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/habits/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/habits/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
