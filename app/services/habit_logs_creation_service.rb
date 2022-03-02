module HabitLogsCreationService 
  def self.create(habit_params, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    habit = user.habits.order("created_at").last
    num_logs = HabitLogsCreationService.get_num_logs(date1, date2)
    current_date = date1
    num_logs.times {
      log = habit.habit_logs.build(scheduled_at: "#{current_date}")
      habit.habit_logs << log
      current_date += 1.day       
    }
  end
  
  def self.create_initial_logs(date1, date2)
    today = Date.today
    next_saturday = today.end_of_week(start_day = :sunday)
   if date1 > next_saturday
     puts "create no logs because background job will take care of it"
   elsif date2 < next_saturday
     puts "create logs from date 1 to date 2 because date 2 is sooner than Saturday and we don't need a log for saturday"
   else
     puts "create logs from date1 till next saturday"
   end
  end  

  def self.get_num_logs(date1, date2)
    num_logs = (date2 - date1).to_i
    num_logs += 1
  end
end  