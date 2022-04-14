module HabitLogsCreationService 
  def self.create_logs(habit_plan, week_type)
    date_range = determine_date_range(habit_plan, week_type)

    return if !date_range
    date_range.each do |date|
      log = habit_plan.habit_logs.build(scheduled_at: date.to_s)
      habit_plan.habit_logs << log     
    end
  end

  def self.create_initial_logs(habit_plan)
    create_logs(habit_plan, "current_week")
    if Date.today.saturday?
      create_logs(habit_plan, "next_week")                                                 
    end
  end

  def self.determine_date_range(habit_plan, week_type)
    plan_start = habit_plan.start_datetime.to_datetime
    plan_end = habit_plan.end_datetime.to_datetime
 
    if week_type == "current_week"
      week_start = Date.today.beginning_of_week(:sunday)
      week_end = Date.today.end_of_week(:sunday)
    else
      week_start = Date.today.next_occurring(:sunday)
      week_end = week_start.end_of_week(:sunday)
    end

    range_start = determine_range_start(plan_start, week_start, week_end)
    range_end = determine_range_end(plan_end, week_start, week_end)

    return if !range_start || !range_end

    range_start..range_end
  end

  def self.determine_range_start(plan_start, week_start, week_end)
    return if plan_start > week_end

    if plan_start > week_start
      plan_start
    else
      week_start
    end
  end

  def self.determine_range_end(plan_end, week_start, week_end)
    return if plan_end < week_start

    if plan_end < week_end
      plan_end
    else
      week_end
    end
  end
end
