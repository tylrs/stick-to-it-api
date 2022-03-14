module HabitPlanDataMigrationService
  def self.update_legacy_data
    Habit.all.each do |habit|
      start_datetime = habit.created_at
      end_datetime = habit.created_at + 3.days
      habit_plan = HabitPlan.create!(habit_id: habit.id, user_id: habit.creator_id, start_datetime: start_datetime, end_datetime: end_datetime)
      current_date = start_datetime
      4.times {
        log = habit_plan.habit_logs.build(scheduled_at: "#{current_date}")
        habit_plan.habit_logs << log
        current_date += 1.day       
      }
    end
  end
end