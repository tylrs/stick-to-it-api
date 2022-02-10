FactoryBot.define do
  factory :user do
    name {"Jim Bob"}
    username {"jimbob79"}
    email {"jimbob7@example.com"}
    password {"123456"}
    password_confirmation {"123456"}
  end
end