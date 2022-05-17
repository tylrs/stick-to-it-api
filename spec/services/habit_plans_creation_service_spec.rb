require "rails_helper"

RSpec.describe HabitPlansCreationService do
  describe ".create_partner_plans" do
    before do
      allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
    end

    context "when the habit plan and recipient ids are valid" do
      let(:habit_plan) { create(:habit_plan) }
      let(:recipient) { create(:user) }

      it "creates a copy of the original habit plan for the recipient" do
        described_class.create_partner_plans(habit_plan.id, recipient.id)

        expect(recipient.habit_plans.first).to have_attributes(
          user_id: recipient.id,
          habit_id: habit_plan.habit_id,
          start_datetime: habit_plan.start_datetime,
          end_datetime: habit_plan.end_datetime
        )
      end

      it "calls create_initial_logs" do
        expect(HabitLogsCreationService).to receive(:create_initial_logs)

        described_class.create_partner_plans(habit_plan.id, recipient.id)
      end
    end
  end
end
