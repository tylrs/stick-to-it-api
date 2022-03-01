class CreateWeeklyHabitLogsJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3

  def perform
    date = Date.today
    puts "This job ran on #{date}"
    puts "This Job will be scheduled"
  end

end
