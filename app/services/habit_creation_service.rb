module HabitCreationService 
  def self.create(habit_params, habit, user)
    date1 = Date.parse(habit_params[:start_datetime])
    date2 = Date.parse(habit_params[:end_datetime])
    num_logs = (date2 - date1).to_i
    num_logs += 1
    habit = user.habits.order("created_at").last
    current_date = date1
    num_logs.times {
      log = habit.habit_logs.build(scheduled_at: "#{current_date}")
      habit.habit_logs << log
      current_date += 1.day       
    }
  end   
end  