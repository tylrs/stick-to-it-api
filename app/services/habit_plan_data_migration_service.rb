module HabitPlanDataMigrationService
  def self.update_legacy_data
    Habit.includes(:habit_logs).each do |habit|
      start_datetime = habit.habit_logs.first.scheduled_at
      end_datetime = habit.habit_logs.last.scheduled_at
      habit_plan = HabitPlan.create!(habit_id: habit.id, user_id: habit.user_id, start_datetime: start_datetime, end_datetime: end_datetime)
      habit.habit_logs.update_all!(habit_plan_id: habit_plan.id)
    end
  end
end