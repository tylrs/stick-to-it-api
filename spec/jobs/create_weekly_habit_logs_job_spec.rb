require 'rails_helper'

RSpec.describe CreateWeeklyHabitLogsJob, type: :job do
  it "Should enqueue a job" do
    ActiveJob::Base.queue_adapter = :test
    expect {CreateWeeklyHabitLogsJob.perform_later}.to have_enqueued_job
  end
end
