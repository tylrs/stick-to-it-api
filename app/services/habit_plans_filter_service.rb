module HabitPlansFilterService
  def self.get_week_and_partner_plans(user_id)
    habit_ids = Habit.includes(:habit_plans).where(habit_plans: { user_id: user_id }).ids
    HabitPlan.with_current_week_logs
             .includes(:user, :habit)
             .where(habit_id: [habit_ids])
  end

  def self.get_today_and_partner_plans(user_id)
    habit_ids = Habit.includes(:habit_plans).where(habit_plans: { user_id: user_id }).ids
    HabitPlan.includes(:user, :habit, :habit_logs)
             .where(habit_id: [habit_ids], habit_logs: { scheduled_at: Date.today })
  end

  def self.get_next_week_plans
    next_sunday = Date.today.next_occurring(:sunday)
    following_saturday = next_sunday.next_occurring(:saturday)
    HabitPlan.where(start_datetime: ..following_saturday, end_datetime: next_sunday..)
  end
end
