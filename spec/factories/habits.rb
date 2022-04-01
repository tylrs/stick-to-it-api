FactoryBot.define do
  factory :habit do
    name { Faker::Verb.ing_form }
    description { "Every day" }
    creator
    habit_plans { association :habit_plan, habit: instance, user: creator }
  end
end