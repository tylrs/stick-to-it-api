module HabitPlansFilterService
  def self.get_week_and_partner_plans(user_id)
    habit_ids = Habit.includes(:habit_plans).where(habit_plans: { user_id: user_id }).ids
    HabitPlan.with_current_week_logs
             .includes(:user, :habit)
             .where(habit_id: [habit_ids])
  end

  def self.get_today_and_partner_plans(user_id)
    habit_ids = Habit.includes(:habit_plans).where(habit_plans: { user_id: user_id }).ids
    habits = HabitPlan.includes(:user, :habit, :habit_logs)
                      .where(habit_id: [habit_ids], habit_logs: { scheduled_at: Date.today })
  end

  def self.get_next_week_plans
    next_sunday = Date.today.next_occurring(:sunday)
    following_saturday = next_sunday.next_occurring(:saturday)
    HabitPlan.where(start_datetime: ..following_saturday, end_datetime: next_sunday..)
  end

  def self.determine_next_week_range(habit_plan)
    next_sunday = Date.today.next_occurring(:sunday)
    following_saturday = next_sunday.next_occurring(:saturday)
    range_beginning = habit_plan.start_datetime.to_datetime
    range_end = habit_plan.end_datetime.to_datetime
    range_beginning = next_sunday if range_beginning < next_sunday
    range_end = following_saturday if range_end > following_saturday
    ranges = { range_beginning: range_beginning, range_end: range_end }
  end
end
