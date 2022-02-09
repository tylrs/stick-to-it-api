module HabitLogsWeeklyService
  def self.get_logs(user_id)
    week_start = Date.today
    if !week_start.sunday?
      week_start = week_start.beginning_of_week(start_day = :sunday)
    end
    habits = Habit.includes(:habit_logs)
                  .where(user_id: user_id, habit_logs:{scheduled_at: week_start..(week_start + 6.days)})
  end
end