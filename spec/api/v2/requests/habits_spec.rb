require "rails_helper"

RSpec.describe "Habits v2", type: :request do
  describe ".create" do
    let(:user) {create(:user)}
    let(:token) {token = JsonWebTokenService.encode(user_id: user.id)}
    let(:headers) {{"Content-type": "application/json", "Authorization": "Bearer #{token}"}}
    let(:habit_info) {{
      name: "Running",
      description: "Run every day",
      start_datetime: "2022/02/02",
      end_datetime: "2022/02/08"
    }}

    before do |test|
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)

      unless test.metadata[:skip_before]
        post "/api/v2/users/#{user.id}/habits", 
             headers: headers, 
             params: JSON.generate(habit_info) 
      end
    end

    it "should respond with a success status" do
      expect(response.status).to eq 201
    end

    it "should create a habit", :skip_before do
      expect {
        post "/api/v2/users/#{user.id}/habits", 
        headers: headers, 
        params: JSON.generate(habit_info)
      }.to change {Habit.count}
    end

    it "should respond with the created habit" do
      expect(json.symbolize_keys).to include(
        id: an_instance_of(Integer),
        creator_id: user.id,
        name: "Running",
        description: "Run every day"
      )
    end

    it "should create a habit plan", :skip_before do
      expect {
        post "/api/v2/users/#{user.id}/habits", 
        headers: headers, 
        params: JSON.generate(habit_info)
      }.to change {HabitPlan.count}
    end

    context "when the end date is on or after next Saturday" do
      it "should create habit logs", :skip_before do
        expect {
          post "/api/v2/users/#{user.id}/habits", 
          headers: headers, 
          params: JSON.generate(habit_info)
        }.to change {HabitLog.count}.by(4)
      end
    end

    context "when the end date is before next Saturday" do
      let(:habit_info) {{
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/04"
      }}

      it "should create habit logs until the end date", :skip_before do
        expect {
          post "/api/v2/users/#{user.id}/habits", 
          headers: headers, 
          params: JSON.generate(habit_info)
        }.to change {HabitLog.count}.by(3)
      end
    end

    context "when the start date is after next Saturday" do
      let(:habit_info) {{
        name: "Running",
        description: "Run every day",
        start_datetime: "2022/02/13",
        end_datetime: "2022/02/20"
      }}

      it "should not create habit logs", :skip_before do
        expect {
          post "/api/v2/users/#{user.id}/habits", 
          headers: headers, 
          params: JSON.generate(habit_info)
        }.to_not change {HabitLog.count}
      end
    end

    context "when some required parameters are empty" do
      let(:habit_info) {{        
        name: "Running",
        description: "",
        start_datetime: "2022/02/13",
        end_datetime: "2022/02/20"
      }}
  
      it "should return an error code" do        
        expect(response.status).to eq 422
      end

      it "should respond with specific error messages" do
        errors = json["errors"]
        
        expect(errors[0]).to eq "Description can't be blank"
      end

      it "should not be able to create a habit", :skip_before do
        expect {
          post "/api/v2/users/#{user.id}/habits", 
          headers: headers, 
          params: JSON.generate(habit_info)
        }.to_not change {Habit.count}
      end
    end
  end
end
