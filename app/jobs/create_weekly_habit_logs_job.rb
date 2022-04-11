class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3

  def perform
    habit_plans = HabitPlansFilterService.get_next_week_plans
    habit_plans.each do |habit_plan|
      range_beginning, range_end = HabitPlansFilterService.determine_next_week_range(habit_plan)
                                                          .values_at(:range_beginning, :range_end)
      HabitLogsCreationService.create_logs(range_beginning..range_end, habit_plan)
    end
  end
end
