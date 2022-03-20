module HabitLogsCreationService 
  def self.create(habit_params, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    today = Date.today  
    # today = Date.new(2022,03,19)
    @next_saturday = today.end_of_week(:sunday)
    habit_plan = user.habit_plans.order("created_at").last
    if today == @next_saturday
      #need to create today's and next week's logs together
    end
    if date1 <= @next_saturday
      self.create_current_week_logs(date1, date2, habit_plan)
    end
  end

  def self.create_current_week_logs(date1, date2, habit_plan)
    date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(date1, date2)
    num_logs = HabitLogsCreationService.get_num_logs(date1, date_limit)
    HabitLogsCreationService.create_logs(num_logs, date1, habit_plan)
  end
  
  def self.determine_date_limit_initial_creation(date1, date2)
    @date_limit
    if date1 < @next_saturday && date2 >= @next_saturday
      @date_limit = @next_saturday
    elsif date2 < @next_saturday
      @date_limit = date2
    elsif date1 == @next_saturday
      puts "do something"
    end
    @date_limit
    # debugger
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