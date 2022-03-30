module HabitLogsCreationService 
  def self.create(habit_params, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    today = Date.today  
    next_saturday = today.end_of_week(:sunday)
    habit_plan = user.habit_plans.order("created_at").last
    if date1 <= next_saturday
      self.create_current_week_logs(date1, date2, habit_plan, next_saturday)
    end
    if today == next_saturday && date1 <= next_saturday.next_occurring(:saturday) 
      self.create_next_week_logs(habit_plan)                                                 
    end
  end

  def self.create_current_week_logs(date1, date2, habit_plan, next_saturday)
    date_limit = self.determine_date_limit_initial_creation(date1, date2, next_saturday)
    num_logs = self.get_num_logs(date1, date_limit)
    self.create_logs(num_logs, date1, habit_plan)
  end

  def self.create_next_week_logs(habit_plan)
    range_beginning, range_end = HabitPlansFilterService.determine_next_week_range(habit_plan)
                                                        .values_at(:range_beginning, :range_end)
    num_logs = self.get_num_logs(range_beginning, range_end)
    self.create_logs(num_logs, range_beginning, habit_plan) 
  end
  
  def self.determine_date_limit_initial_creation(date1, date2, next_saturday)
    date_limit = if date1 <= next_saturday && date2 >= next_saturday
      next_saturday
    elsif date2 < next_saturday
      date2
    end
    date_limit
  end
  
  def self.get_num_logs(date1, date_limit)
    num_logs = (date_limit - date1).to_i
    num_logs += 1
  end

  def self.create_logs(num_logs, date1, habit_plan)
    current_date = date1
    num_logs.times {
      log = habit_plan.habit_logs.build(scheduled_at: "#{current_date}")
      habit_plan.habit_logs << log
      current_date += 1.day       
    }
  end
end  