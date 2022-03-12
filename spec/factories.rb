FactoryBot.define do
  factory :user, aliases: [:creator] do
    name { "Jim Bob" }
    username { "jimbob79" }
    email { "jimbob7@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
  end

  factory :habit do
    name { "Running" }
    description { "Run every day" }
    creator
    habit_plans { association :habit_plan, habit: instance, user: creator }
  end

  factory :habit_plan do
    start_datetime { "2022-02-02 00:00:00" }
    end_datetime { "2022-02-10 00:00:00" }
    user
    habit { association :habit, habit_plans: [instance], creator: user }
  end
  
  factory :habit_log do
    scheduled_at { "2022/02/02" }
    completed_at { nil }
    habit_plan
  end
end