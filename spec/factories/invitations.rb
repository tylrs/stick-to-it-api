FactoryBot.define do
  factory :invitation do
    sender
    recipient
    recipient_email { recipient.email }
    habit_plan { association :habit_plan, invitation: instance, user: sender }
    status { 0 }
  end
end
