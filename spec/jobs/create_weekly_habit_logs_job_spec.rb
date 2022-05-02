require "rails_helper"

RSpec.describe CreateWeeklyHabitLogsJob, type: :job do
  it "enqueues a job" do
    ActiveJob::Base.queue_adapter = :test
    expect { described_class.perform_later }.to have_enqueued_job
  end
end
