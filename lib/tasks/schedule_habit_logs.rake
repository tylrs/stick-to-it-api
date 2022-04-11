namespace :habit_logs_scheduler do
  desc "Schedule Week Habit Logs"
  task schedule_week_habit_logs: :environment do
    CreateWeeklyHabitLogsJob.perform_later
  end  
end
