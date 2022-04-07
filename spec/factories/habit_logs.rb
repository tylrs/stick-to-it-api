FactoryBot.define do
  factory :habit_log do
    scheduled_at { Date.new(2022,2,2) }
    completed_at { nil }
    habit_plan
  end
end