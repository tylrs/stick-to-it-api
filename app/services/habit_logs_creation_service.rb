module HabitLogsCreationService 
  def self.create(habit_params, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    today = Date.today
    @next_saturday = today.end_of_week(start_day = :sunday)
    if date1 <= @next_saturday
      date_limit = HabitLogsCreationService.determine_date_limit(date1, date2)
      num_logs = HabitLogsCreationService.get_num_logs(date1, date_limit)
      HabitLogsCreationService.create_logs(num_logs, date1, user)
    end
    #Should I return something if the starting date is later than Saturday?
  end
  
  def self.determine_date_limit(date1, date2)
    @date_limit

    if date1 < @next_saturday && date2 >= @next_saturday
      @date_limit = @next_saturday
    elsif date2 < @next_saturday
      @date_limit = date2
    end
    @date_limit
  end
  
  def self.get_num_logs(date1, date_limit)
    num_logs = (date_limit - date1).to_i
    num_logs += 1
  end

  def self.create_logs(num_logs, date1, user)
    habit = user.habits.order("created_at").last
    current_date = date1
    num_logs.times {
      log = habit.habit_logs.build(scheduled_at: "#{current_date}")
      habit.habit_logs << log
      current_date += 1.day       
    }
  end
end  