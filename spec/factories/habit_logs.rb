FactoryBot.define do
  factory :habit_log do
    scheduled_at { "2022/02/02" }
    completed_at { nil }
    habit_plan
  end
end