require "rails_helper"

RSpec.describe HabitPlansFilterService do
  let(:habit_log) { create(:habit_log) }
  let(:user) { habit_log.habit_plan.user }
  let(:habit_plan) { habit_log.habit_plan }
  let(:habit_plan_2) { create(:habit_plan, {start_datetime: "2022/02/06", user: user}) }
  let(:habit) { habit_plan.habit }

  before do
      FactoryBot.create_list(:habit_log, 3, habit_plan_id: habit_plan.id) do |habit_log, i|
        date = Date.new(2022,2,3)
        date += i.days
        habit_log.scheduled_at = date
        habit_log.save
      end
  
      create(:habit_log, {scheduled_at: "2022/02/06", habit_plan: habit_plan_2})
  end

  describe ".get_week_and_partner_plans" do
    let(:habit_plans) { HabitPlansFilterService.get_week_and_partner_plans(user.id) }

    before do
      allow(Date).to receive(:today).and_return Date.new(2022,2,1)
    end

    it "returns user's habit plans only for the current week" do
      expect(habit_plans.count).to eq 1
    end

    it "returns matching user" do
      expect(habit_plans[0].user).to eq user
    end

    it "returns habit for each habit plan" do
      expect(habit_plans[0].habit).to eq habit
    end

    it "returns only current week's logs" do
      expect(habit_plans[0].habit_logs.count).to eq 4
    end

    context "when user has a partner on a habit" do
      let(:partner) { create(:user) }
      let(:partner_habit_plan) { create(:habit_plan, {user: partner, habit: habit}) }

      before do
        FactoryBot.create_list(:habit_log, 4, habit_plan_id: partner_habit_plan.id) do |habit_log, i|
          date = Date.new(2022,2,2)
          date += i.days
          habit_log.scheduled_at = date
          habit_log.save
        end
      end

      it "returns partner's habit plan only for the current week" do
        expect(habit_plans.count).to eq 2
      end
  
      it "returns matching partner" do
        expect(habit_plans[1].user).to eq partner
      end
  
      it "returns habit for partner's habit plan" do
        expect(habit_plans[1].habit).to eq habit
      end
  
      it "returns only current week's logs" do
        expect(habit_plans[1].habit_logs.count).to eq 4
      end
    end

    context "when a user has no habit plans for the current week" do
      let(:user) { create(:user) }

      it "returns no habit plans" do
        response = HabitPlansFilterService.get_week_and_partner_plans(user.id)
        
        expect(response.count).to eq 0
      end
    end
  end
end