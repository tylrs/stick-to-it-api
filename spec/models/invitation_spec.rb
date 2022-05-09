require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:recipient) }
    it { is_expected.to belong_to(:habit_plan) }
  end

  describe "validations" do
    
  end
end