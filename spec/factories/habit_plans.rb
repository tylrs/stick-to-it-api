FactoryBot.define do
  factory :habit_plan do
    start_datetime { "2022-02-02 00:00:00" }
    end_datetime { "2022-02-10 00:00:00" }
    user
    habit { association :habit, habit_plans: [instance], creator: user }
  end
end