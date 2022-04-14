module HabitLogsCreationService 
  def self.create(habit_plan, user)
    plan_start = habit_plan.start_datetime.to_datetime
    plan_end = habit_plan.end_datetime.to_datetime
    today = Date.today  
    next_saturday = today.end_of_week(:sunday)
    create_current_week_logs(plan_start, plan_end, habit_plan, next_saturday) if plan_start <= next_saturday
    if today == next_saturday && plan_start <= next_saturday.next_occurring(:saturday) 
      create_next_week_logs(habit_plan)                                                 
    end
  end

  def self.create_current_week_logs(plan_start, plan_end, habit_plan, next_saturday)
    date_limit = determine_date_limit_initial_creation(plan_start, plan_end, next_saturday)
    create_logs(plan_start..date_limit, habit_plan)
  end

  def self.create_next_week_logs(habit_plan)
    range_beginning, range_end = HabitPlansFilterService.determine_next_week_range(habit_plan)
                                                        .values_at(:range_beginning, :range_end)
    create_logs(range_beginning..range_end, habit_plan) 
  end
  
  def self.determine_date_limit_initial_creation(plan_start, plan_end, next_saturday)
    return if plan_start > next_saturday
  
    plan_end >= next_saturday ? next_saturday : plan_end
  end

  def self.determine_date_range(habit_plan, type)
    plan_start = habit_plan.start_datetime.to_datetime
    plan_end = habit_plan.end_datetime.to_datetime
    current_sunday = Date.today.beginning_of_week(:sunday)
    current_saturday = Date.today.end_of_week(:sunday)
    next_sunday = Date.today.next_occurring(:sunday)
    next_saturday = next_sunday.next_occurring(:saturday)

    return if plan_start > current_saturday && type == "current_week"
    return if plan_start > next_saturday && type == "next_week"
    return if plan_end < next_sunday && type == "next_week"

    if type == "current_week"
      range_start = current_sunday
      range_end = current_saturday
    else
      range_start = next_sunday
      range_end = next_saturday
    end

    if plan_start >= current_sunday && type == "current_week"
      range_start = plan_start 
    end

    if plan_end < current_saturday && type == "current_week"
      range_end = plan_end
    end

    if plan_start > next_sunday && type == "next_week"
      range_start = plan_start
    end

    if plan_end < next_saturday && type == "next_week"
      range_end = plan_end
    end

    range_start..range_end
  end

  def self.create_logs(date_range, habit_plan)
    date_range.each do |date|
      log = habit_plan.habit_logs.build(scheduled_at: date.to_s)
      habit_plan.habit_logs << log     
    end
  end
end
