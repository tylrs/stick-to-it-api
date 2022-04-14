class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3

  def perform
    habit_plans = HabitPlansFilterService.get_next_week_plans
    habit_plans.each do |habit_plan|
      HabitLogsCreationService.create_next_week_logs(habit_plan)
    end
  end
end
