class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3

  def perform
    next_sunday = Date.today.next_occurring(:sunday)
    following_saturday = next_sunday.next_occurring(:saturday)
    habit_plans = HabitPlan.where(start_datetime: ..following_saturday, end_datetime: next_sunday..)
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
