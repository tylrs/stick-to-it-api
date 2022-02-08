module HabitLogsWeeklyService
  def self.get_logs(habit_id)
    week_start = Date.today
    if !week_start.sunday?
      week_start = week_start.beginning_of_week(start_day = :sunday)
    end
    logs = HabitLog.where(scheduled_at: week_start..(week_start + 6.days), habit_id: habit_id)
                   .select(:id, :habit_id, :scheduled_at, :completed_at)
    logs
  end
end