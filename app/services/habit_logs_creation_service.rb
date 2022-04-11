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
    num_logs = get_num_logs(plan_start, date_limit)
    create_logs(num_logs, plan_start, habit_plan)
  end

  def self.create_next_week_logs(habit_plan)
    range_beginning, range_end = HabitPlansFilterService.determine_next_week_range(habit_plan)
                                                        .values_at(:range_beginning, :range_end)
    num_logs = get_num_logs(range_beginning, range_end)
    create_logs(num_logs, range_beginning, habit_plan) 
  end
  
  def self.determine_date_limit_initial_creation(plan_start, plan_end, next_saturday)
    return if plan_start > next_saturday
  
    plan_end >= next_saturday ? next_saturday : plan_end
  end
  
  def self.get_num_logs(range_beginning, date_limit)
    num_logs = (date_limit - range_beginning).to_i
    num_logs += 1
  end

  def self.create_logs(num_logs, first_log_date, habit_plan)
    current_date = first_log_date
    num_logs.times do
      log = habit_plan.habit_logs.build(scheduled_at: current_date.to_s)
      habit_plan.habit_logs << log
      current_date += 1.day       
    end
  end
end
