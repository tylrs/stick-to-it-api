module HabitPlansFilterService
  def self.get_week_plans(user_id)
    week_start = Date.today
    if !week_start.sunday?
      week_start = week_start.beginning_of_week(start_day = :sunday)
    end
    habit_plans = HabitPlan.includes(:habit, :habit_logs)
                           .where(user_id: user_id, habit_logs:{scheduled_at: week_start..(week_start + 6.days)})
  end

  def self.get_today_plans(user_id)
    habits = HabitPlan.includes(:habit, :habit_logs)
                  .where(user_id: user_id, habit_logs:{scheduled_at: Date.today})
  end
end