require "rails_helper"

RSpec.describe "Users v2", type: :request do
  describe "#create user" do
    let(:headers) { {"Content-type": "application/json"} }

    context "when all required user info is submitted" do
      let(:user_details) { { 
        name: "John Bob",
        username: "johnbob79",
        email: "johnbob7@example.com",
        password: "123456",
        password_confirmation: "123456"
      } }
      
      it "responds with status created" do
        post "/api/v2/users", headers: headers, params: JSON.generate(user_details)

        expect(response).to have_http_status(:created)
      end

      it "responds with the created user info" do
        post "/api/v2/users", headers: headers, params: JSON.generate(user_details)

        user_keys = %w[name username email id]

        expect(parsed_response.keys).to match_array(user_keys)
      end
      
      it "creates a user in the database" do
        expect { post "/api/v2/users", 
                 headers: headers, 
                 params: JSON.generate(user_details) 
               }.to change { User.count }.by 1
      end      
    end

    context "when any required parameters are empty" do
      let(:user_details) { {
        name: "",
        username: "johnbob79",
        email: "johnbob7@example.com",
        password: "123456",
        password_confirmation: ""
      } }

      it "responds with unprocessable entity status" do
        post "/api/v2/users", headers: headers, params: JSON.generate(user_details)

        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "responds with specific error messages" do
        post "/api/v2/users", headers: headers, params: JSON.generate(user_details)

        expect(parsed_response["errors"]).to include( 
          "Password confirmation doesn't match Password",
          "Name can't be blank"
        )
      end

      it "does not create a user in the database" do
        expect { post "/api/v2/users", 
          headers: headers, 
          params: JSON.generate(user_details) 
        }.to_not change { User.count }
      end
    end
  end
end