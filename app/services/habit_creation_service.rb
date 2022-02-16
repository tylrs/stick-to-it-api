module HabitCreationService 
  def self.create(habit_params, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    habit = user.habits.order("created_at").last
    num_logs = HabitCreationService.get_num_logs(date1, date2)
    current_date = date1
    num_logs.times {
      log = habit.habit_logs.build(scheduled_at: "#{current_date}")
      habit.habit_logs << log
      current_date += 1.day       
    }
  end   

  def self.get_num_logs(date1, date2)
    num_logs = (date2 - date1).to_i
    num_logs += 1
  end
end  