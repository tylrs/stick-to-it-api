FactoryBot.define do
  factory :invitation do
    sender
    recipient_email { Faker::Internet.safe_email }
    habit_plan { association :habit_plan, invitation: instance, user: sender }
    status { 0 }
  end
end
