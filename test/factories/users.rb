FactoryBot.define do
  factory :user do
    name { "test name" }
    username { "test_username" }
    email { "test@email.com" }
    password { "123456asdf" }
  end
end
