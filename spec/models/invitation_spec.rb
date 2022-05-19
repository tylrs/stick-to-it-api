require "rails_helper"

RSpec.describe Invitation, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:habit_plan) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:recipient_email) }

    context "when an invitation associated with the same habit plan already exists and is pending" do
      let!(:habit_plan) { create(:habit_plan) }
      let!(:pending_invitation) { create(:invitation, { habit_plan: habit_plan }) }

      it "should return an error message" do
        new_invitation = build(:invitation, { sender: pending_invitation.sender, habit_plan: pending_invitation.habit_plan })
        new_invitation.valid?

        expect(new_invitation.errors[:habit_plan_limit]).to include("Can only have one pending or accepted invitation per habit plan")
      end
    end

    context "when an invitation associated with the same habit plan already exists and has been accepted" do
      let!(:habit_plan) { create(:habit_plan) }
      let!(:accepted_invitation) { create(:invitation, { habit_plan: habit_plan, status: "accepted" }) }

      it "should return an error message" do
        new_invitation = build(:invitation, { habit_plan: accepted_invitation.habit_plan })
        new_invitation.valid?

        expect(new_invitation.errors[:habit_plan_limit]).to include("Can only have one pending or accepted invitation per habit plan")
      end
    end
  end
end
