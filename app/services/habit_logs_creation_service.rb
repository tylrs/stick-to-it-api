module HabitLogsCreationService 
  def self.create(habit_params, user)
    habit_start = Date.parse(habit_params[:start_datetime])
    habit_end = Date.parse(habit_params[:end_datetime])
    today = Date.today  
    next_saturday = today.end_of_week(:sunday)
    habit_plan = user.habit_plans.order("created_at").last
    create_current_week_logs(habit_start, habit_end, habit_plan, next_saturday) if habit_start <= next_saturday
    if today == next_saturday && habit_start <= next_saturday.next_occurring(:saturday) 
      create_next_week_logs(habit_plan)                                                 
    end
  end

  def self.create_current_week_logs(habit_start, habit_end, habit_plan, next_saturday)
    date_limit = determine_date_limit_initial_creation(habit_start, habit_end, next_saturday)
    num_logs = get_num_logs(habit_start, date_limit)
    create_logs(num_logs, habit_start, habit_plan)
  end

  def self.create_next_week_logs(habit_plan)
    range_beginning, range_end = HabitPlansFilterService.determine_next_week_range(habit_plan)
                                                        .values_at(:range_beginning, :range_end)
    num_logs = get_num_logs(range_beginning, range_end)
    create_logs(num_logs, range_beginning, habit_plan) 
  end
  
  def self.determine_date_limit_initial_creation(habit_start, habit_end, next_saturday)
    return if habit_start > next_saturday
  
    habit_end >= next_saturday ? next_saturday : habit_end
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
