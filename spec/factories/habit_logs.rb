FactoryBot.define do
  factory :habit_log do
    scheduled_at { Faker::Date.in_date_period(year: 2022) }
    completed_at { nil }
    habit_plan
  end
end