module HabitLogsCreationService 
  def self.create_logs(habit_plan, week_type)
    date_range = determine_date_range(habit_plan, week_type)

    return nil unless date_range

    date_range.each do |date|
      log = habit_plan.habit_logs.build(scheduled_at: date.to_s)
      habit_plan.habit_logs << log     
    end
  end

  def self.create_initial_logs(habit_plan)
    create_logs(habit_plan, "current_week")
    create_logs(habit_plan, "next_week") if Date.today.saturday?
  end

  def self.determine_date_range(habit_plan, week_type)
    plan_start = habit_plan.start_datetime.to_datetime
    plan_end = habit_plan.end_datetime.to_datetime
    week_start = DatesInWeekService.get_week_start(week_type)
    week_end = DatesInWeekService.get_week_end(week_type)
    range_start = determine_range_start(plan_start, week_start, week_end)
    range_end = determine_range_end(plan_end, week_start, week_end)

    return nil unless range_start && range_end

    range_start..range_end
  end

  def self.determine_range_start(plan_start, week_start, week_end)
    return nil if plan_start > week_end
    
    plan_start > week_start ? plan_start : week_start
  end

  def self.determine_range_end(plan_end, week_start, week_end)
    return nil if plan_end < week_start

    plan_end < week_end ? plan_end : week_end
  end
end
