FactoryBot.define do
  factory :habit_plan do
    start_datetime { Date.new(2022, 2, 2) }
    end_datetime { Date.new(2022, 2, 10) }
    user
    habit { association :habit, habit_plans: [instance], creator: user }
  end
end
