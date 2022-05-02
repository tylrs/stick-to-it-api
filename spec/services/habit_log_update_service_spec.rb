require "rails_helper"

RSpec.describe HabitLogUpdateService do
  describe ".update_log" do
    it "Marks an incomplete habit log as completed" do
      habit_log = create(:habit_log)
      updated_habit_log = described_class.update(habit_log)

      expect(updated_habit_log.completed_at).to eq habit_log.scheduled_at
    end

    it "Marks a completed habit log as incomplete" do
      habit_log = create(:habit_log, { completed_at: Date.new(2022, 2, 2) }) 
      updated_habit_log = described_class.update(habit_log)

      expect(updated_habit_log.completed_at).to be_nil
    end
  end
end
