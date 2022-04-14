module HabitLogsCreationService 
  def self.create(habit_plan, user)
    plan_start = habit_plan.start_datetime.to_datetime
    plan_end = habit_plan.end_datetime.to_datetime
    today = Date.today  
    next_saturday = today.end_of_week(:sunday)
    create_current_week_logs(habit_plan) if plan_start <= next_saturday
    if today == next_saturday && plan_start <= next_saturday.next_occurring(:saturday) 
      create_next_week_logs(habit_plan)                                                 
    end
  end

  def self.create_current_week_logs(habit_plan)
    range = determine_date_range(habit_plan, "current_week")
    create_logs(range, habit_plan) 
  end

  def self.create_next_week_logs(habit_plan)
    range = determine_date_range(habit_plan, "next_week")
    create_logs(range, habit_plan) 
  end
  
  def self.determine_date_limit_initial_creation(plan_start, plan_end, next_saturday)
    return if plan_start > next_saturday
  
    plan_end >= next_saturday ? next_saturday : plan_end
  end

  def self.determine_date_range(habit_plan, type)
    plan_start = habit_plan.start_datetime.to_datetime
    plan_end = habit_plan.end_datetime.to_datetime
 
    if type == "current_week"
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

  def self.create_logs(date_range, habit_plan)
    date_range.each do |date|
      log = habit_plan.habit_logs.build(scheduled_at: date.to_s)
      habit_plan.habit_logs << log     
    end
  end
end
