FactoryBot.define do
  factory :habit do
    name { "Running" }
    description { "Run every day" }
    creator
    habit_plans { association :habit_plan, habit: instance, user: creator }
  end
end