class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3

  def perform
    next_sunday = Date.next_occuring(:sunday)
    
  end

end
