require "rails_helper"

RSpec.describe "Invitations v2", type: :request do
  let(:habit_plan) { create(:habit_plan) }
  let(:user) { habit_plan.user }
  let(:token) { JsonWebTokenService.encode(user_id: user.id) }
  let(:headers) { { "Content-type": "application/json", "Authorization": "Bearer #{token}" } }
  let(:recipient_info) { { recipient_name: "Bob", recipient_email: "bob.friend@example.com" } }

  it_behaves_like "a protected route" do
    let(:request_type) { :post }
    let(:path) do
      "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/invitation/create"
    end     
  end

  describe "#create" do
    context "when the invitation record has been successfully created" do
      before do
        post "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/invitation/create",
             headers: headers,
             params: JSON.generate(recipient_info)
      end

      it "returns http success" do
        expect(response).to be_ok
      end

      it "returns a success message" do
        expect(parsed_response["message"]).to eq "Email Sent"
      end

      it "creates an Invitation record" do
        expect do
          post "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/invitation/create",
               headers: headers,
               params: JSON.generate(recipient_info)
        end.to change { user.sent_invites.count }.by(1)
      end
    end

    context "when the invitation record creation fails" do
      let(:recipient_info) { { recipient_name: "Bob", recipient_email: "" } }
      before do
        post "/api/v2/users/#{user.id}/habit_plans/#{habit_plan.id}/invitation/create",
             headers: headers,
             params: JSON.generate(recipient_info)
      end

      it "returns an unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        expect(parsed_response["errors"]).to contain_exactly("Recipient email can't be blank", "Recipient email is invalid")
      end
    end

    context "when the user cannot be found" do
      before do
        post "/api/v2/users/500/habit_plans/#{habit_plan.id}/invitation/create",
             headers: headers,
             params: JSON.generate(recipient_info)
      end

      it "returns a not found status" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        expect(parsed_response["errors"]).to eq "Record not found"
      end
    end

    context "when the habit plan cannot be found" do
      before do
        post "/api/v2/users/#{user.id}/habit_plans/500/invitation/create",
             headers: headers,
             params: JSON.generate(recipient_info)
      end

      it "returns a not found status" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        expect(parsed_response["errors"]).to eq "Record not found"
      end
    end
  end
end
