FactoryBot.define do
  factory :invitation do
    user { nil }
    recipient_id { "" }
    recipient_email { "MyString" }
    habit_plan { nil }
    status { 1 }
  end
end
