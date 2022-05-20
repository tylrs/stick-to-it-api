FactoryBot.define do
  factory :invitation do
    sender
    recipient_email { Faker::Internet.safe_email }
    habit_plan
    status { 0 }
  end
end
