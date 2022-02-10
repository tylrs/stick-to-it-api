require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "Create" do
    it "should create a user with successful info" do
      user_details = {
        name: "John Bob",
        username: "johnbob79",
        email: "johnbob7@example.com",
        password: "123456",
        password_confirmation: "123456"
      }

      headers = {"CONTENT_TYPE"  => "application/json"}
      post "/users", headers: headers, params: JSON.generate(user_details)
      created_user = User.last

      expect(response.status).to eq 201
      expect(JSON.parse(response.body)["name"]).to eq "John Bob"
      expect(created_user.name).to eq "John Bob"
    end
  end
end
