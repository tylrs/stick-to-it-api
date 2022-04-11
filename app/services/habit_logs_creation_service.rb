module HabitLogsCreationService 
  def self.create(habit_params, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    today = Date.today  
    next_saturday = today.end_of_week(:sunday)
    habit_plan = user.habit_plans.order("created_at").last
    create_current_week_logs(date1, date2, habit_plan, next_saturday) if date1 <= next_saturday
    if today == next_saturday && date1 <= next_saturday.next_occurring(:saturday) 
      create_next_week_logs(habit_plan)                                                 
    end
  end

  def self.create_current_week_logs(date1, date2, habit_plan, next_saturday)
    date_limit = determine_date_limit_initial_creation(date1, date2, next_saturday)
    num_logs = get_num_logs(date1, date_limit)
    create_logs(num_logs, date1, habit_plan)
  end

  def self.create_next_week_logs(habit_plan)
    range_beginning, range_end = HabitPlansFilterService.determine_next_week_range(habit_plan)
                                                        .values_at(:range_beginning, :range_end)
    num_logs = get_num_logs(range_beginning, range_end)
    create_logs(num_logs, range_beginning, habit_plan) 
  end
  
  def self.determine_date_limit_initial_creation(date1, date2, next_saturday)
    return if date1 > next_saturday
  
    date2 >= next_saturday ? next_saturday : date2
  end
  
  def self.get_num_logs(date1, date_limit)
    num_logs = (date_limit - date1).to_i
    num_logs += 1
  end

  def self.create_logs(num_logs, date1, habit_plan)
    current_date = date1
    num_logs.times do
      log = habit_plan.habit_logs.build(scheduled_at: current_date.to_s)
      habit_plan.habit_logs << log
      current_date += 1.day       
    end
  end
end
