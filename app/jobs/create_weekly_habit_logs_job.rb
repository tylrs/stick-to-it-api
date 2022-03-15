class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3

  def perform
    # habit plans filter service . get_new_week_habit_plans
    # determine habit plans num logs
    habit_plans = HabitPlansFilterService.get_next_week_plans
    habit_plans.each do |habit_plan|
      range_beginning = habit_plan.start_datetime.to_datetime
      range_end = habit_plan.end_datetime.to_datetime
      if range_beginning < next_sunday
        range_beginning = next_sunday
      end
      if range_end > following_saturday
        range_end = following_saturday
      end
      num_logs = HabitLogsCreationService.get_num_logs(range_beginning, range_end)
      HabitLogsCreationService.create_logs(num_logs, range_beginning, habit_plan)
    end
  end

end
