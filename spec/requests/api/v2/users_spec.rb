require "rails_helper"

RSpec.describe "Users v2", type: :request do
  describe "#create user" do
    let(:headers) { { "Content-type": "application/json" } }

    context "when all required user info is submitted" do
      let(:user_details) do 
        { 
          name: "John Bob",
          username: "johnbob79",
          email: "johnbob7@example.com",
          password: "123456",
          password_confirmation: "123456"
        }
      end      
      
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
        expect do 
          post "/api/v2/users", 
               headers: headers, 
               params: JSON.generate(user_details) 
        end.to change(User, :count).by 1
      end      
    end

    context "when any required parameters are empty" do
      let(:user_details) do 
        {
          name: "",
          username: "johnbob79",
          email: "johnbob7@example.com",
          password: "123456",
          password_confirmation: ""
        }
      end      

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
        expect do 
          post "/api/v2/users", 
               headers: headers, 
               params: JSON.generate(user_details) 
        end.not_to change(User, :count)
      end
    end
  end

  describe "#show" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let(:token) { JsonWebTokenService.encode(user_id: sender.id) }
    let(:headers) { { "Content-type": "application/json", "Authorization": "Bearer #{token}" } }

    context "when a user matches the requested email" do
      before do
        get "/api/v2/users?email=#{recipient.email}", headers: headers
      end

      it "returns http success" do
        expect(response).to be_ok
      end

      describe "return value" do
        it "returns the correct user's name" do
          expect(parsed_response["name"].to eq recipient.name)
        end

        it "returns the correct user's email" do
          expect(parsed_response["email"].to eq recipient.email)
        end
      end
    end

    context "when a user that matches the requested email cannot be found" do
      it "should return http not found" do
        
      end
    end
  end
end
