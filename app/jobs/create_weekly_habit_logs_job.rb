class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3
  queue_as :default

  def perform()
    puts "job is running"
  end

end
