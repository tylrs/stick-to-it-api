require "rails_helper"

RSpec.describe HabitLog, type: :model do
  describe "HabitLog Relationships" do
    it { should belong_to(:habit) }
  end
end
