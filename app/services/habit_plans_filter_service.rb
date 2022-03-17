module HabitPlansFilterService
  def self.get_week_plans(user_id)
    week_start = Date.today
    if !week_start.sunday?
      week_start = week_start.beginning_of_week(start_day = :sunday)
    end
    habit_plans = HabitPlan.includes(:habit, :habit_logs)
                           .where(user_id: user_id, habit_logs:{scheduled_at: week_start..(week_start + 6.days)})
  end

  def self.get_week_plans_and_partner_plans(user_id)
    week_start = Date.today
    if !week_start.sunday?
      week_start = week_start.beginning_of_week(start_day = :sunday)
    end
    # HabitPlan.create(user_id: 1, habit_id: 46, start_datetime: Date.new(2022,03,13), end_datetime: Date.new(2022,03,30))
    habit_ids = Habit.includes(:habit_plans).where(habit_plans:{user_id: user_id}).ids
    HabitPlan.includes(:user, :habit, :habit_logs)
             .where(habit_id: [habit_ids])
  end

  def self.get_next_week_plans
    next_sunday = Date.today.next_occurring(:sunday)
    following_saturday = next_sunday.next_occurring(:saturday)
    HabitPlan.where(start_datetime: ..following_saturday, end_datetime: next_sunday..)
  end

  def self.get_today_plans(user_id)
    habits = HabitPlan.includes(:habit, :habit_logs)
                      .where(user_id: user_id, habit_logs:{scheduled_at: Date.today})
  end

  def self.determine_next_week_range(habit_plan)
    next_sunday = Date.today.next_occurring(:sunday)
    following_saturday = next_sunday.next_occurring(:saturday)
    range_beginning = habit_plan.start_datetime.to_datetime
    range_end = habit_plan.end_datetime.to_datetime
    if range_beginning < next_sunday
      range_beginning = next_sunday
    end
    if range_end > following_saturday
      range_end = following_saturday
    end
    ranges = {range_beginning: range_beginning, range_end: range_end}
  end
end