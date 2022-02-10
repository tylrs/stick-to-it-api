FactoryBot.define do
  factory :user do
    name {"Jim Bob"}
    username {"jimbob79"}
    email {"jimbob7@example.com"}
    password {"123456"}
    password_confirmation {"123456"}
  end
  
  factory :habit_log do
    scheduled_at {"2022/02/02"}
    completed_at {nil}
    habit
  end

  factory :habit do
    name {"Running"}
    description {"Run every day"}
    user
  end


end