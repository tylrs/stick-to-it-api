module HabitLogUpdateService 
  def self.update(habit_log)
    if habit_log.completed_at
      habit_log.update(completed_at: nil)
    else
      habit_log.update(completed_at: habit_log.scheduled_at)
    end
    habit_log
  end   
end  