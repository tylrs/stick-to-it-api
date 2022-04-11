require "rails_helper"

RSpec.describe "Authentications v2", type: :request do
  describe "#login" do
    let(:user) { create(:user) }
    let(:headers) { { "Content-type": "application/json" } }

    before do
      post "/api/v2/auth/login",
           headers: headers,
           params: JSON.generate(login_params) 
    end
    
    context "when login is successful" do
      let(:login_params) { { email: user.email, password: "123456" } }

      it "returns an ok status" do
        expect(response).to be_ok
      end

      describe "return value" do
        it "includes token, expiration time, and user info" do
          base_keys = %w[token exp user]

          expect(parsed_response.keys).to match_array(base_keys)
        end

        it "includes correct user info" do
          user_keys = %w[id name username email]

          expect(parsed_response["user"].keys).to match_array(user_keys)
        end
      end
    end 

    context "when login is unsuccessful" do
      let(:login_params) { { email: user.email, password: "12" } }

      it "returns an unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns an error message saying unauthorized" do
        expect(parsed_response["error"]).to eq "unauthorized"
      end
    end
  end
end
