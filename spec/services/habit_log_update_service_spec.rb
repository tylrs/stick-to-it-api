require "rails_helper"

RSpec.describe HabitLogUpdateService do
  describe "update log" do
    
    it "should be able to mark an incomplete habit log as completed" do
      habit_log = create(:habit_log)
      updated_habit_log = HabitLogUpdateService.update(habit_log)

      expect(updated_habit_log.completed_at).to eq habit_log.scheduled_at
    end

    it "should be able to mark a completed habit log as incomplete" do
      habit_log = create(:habit_log)
      updated_habit_log = HabitLogUpdateService.update(habit_log)
      updated_habit_log = HabitLogUpdateService.update(updated_habit_log)

      expect(updated_habit_log.completed_at).to eq nil
    end
  end
end