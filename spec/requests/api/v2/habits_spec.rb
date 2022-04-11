require "rails_helper"

RSpec.describe "Habits v2", type: :request do
  describe "#create" do
    let(:user) { create(:user) }
    let(:token) { JsonWebTokenService.encode(user_id: user.id) }
    let(:headers) { { "Content-type": "application/json", "Authorization": "Bearer #{token}" } }
    let(:habit_info) do 
      {
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/08"
      }
    end    

    before do |test|
      allow(Date).to receive(:today).and_return Date.new(2022, 2, 1)

      unless test.metadata[:skip_before]
        post "/api/v2/users/#{user.id}/habits", 
             headers: headers, 
             params: JSON.generate(habit_info) 
      end
    end

    it_behaves_like "a protected route" do
      let(:request_type) { :post }
      let(:path) { "/api/v2/users/#{user.id}/habits" }
    end

    it "responds with created status" do
      expect(response).to have_http_status(:created)
    end

    it "creates a habit", :skip_before do
      expect do
        post "/api/v2/users/#{user.id}/habits", 
             headers: headers, 
             params: JSON.generate(habit_info)
      end.to change { user.habits.count }.by(1)
    end

    it "responds with the created habit" do
      habit_keys = %w[id creator_id name description updated_at created_at]

      expect(parsed_response.keys).to match_array(habit_keys)
    end

    it "creates a habit plan", :skip_before do
      expect do
        post "/api/v2/users/#{user.id}/habits", 
             headers: headers, 
             params: JSON.generate(habit_info)
      end.to change { user.habit_plans.count }.by(1)
    end

    context "when the end date is on or after next Saturday" do
      it "creates habit logs", :skip_before do
        expect do
          post "/api/v2/users/#{user.id}/habits", 
               headers: headers, 
               params: JSON.generate(habit_info)
        end.to change { user.habit_logs.count }.by(4)
      end
    end

    context "when the end date is before next Saturday" do
      let(:habit_info) do 
        {
          name: "Running",
          description: "Run every day",
          start_datetime: "2022/02/02",
          end_datetime: "2022/02/04"
        }
      end      

      it "creates habit logs until the end date", :skip_before do
        expect do
          post "/api/v2/users/#{user.id}/habits", 
               headers: headers, 
               params: JSON.generate(habit_info)
        end.to change { user.habit_logs.count }.by(3)
      end
    end

    context "when the start date is after next Saturday" do
      let(:habit_info) do 
        {
          name: "Running",
          description: "Run every day",
          start_datetime: "2022/02/13",
          end_datetime: "2022/02/20"
        }
      end      

      it "does not create habit logs", :skip_before do
        expect do
          post "/api/v2/users/#{user.id}/habits", 
               headers: headers, 
               params: JSON.generate(habit_info)
        end.to_not change { user.habit_logs.count }
      end
    end

    context "when some required parameters are empty" do
      let(:habit_info) do 
        {        
          name: "Running",
          description: "",
          start_datetime: "2022/02/13",
          end_datetime: "2022/02/20"
        }
      end      
  
      it "returns an unprocessable_entity status" do        
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with specific error messages" do
        errors = parsed_response["errors"]
        
        expect(errors[0]).to eq "Description can't be blank"
      end

      it "does not create a habit", :skip_before do
        expect do
          post "/api/v2/users/#{user.id}/habits", 
               headers: headers, 
               params: JSON.generate(habit_info)
        end.to_not change { user.habits.count }
      end
    end
  end
end
