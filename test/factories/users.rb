FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "test name #{n}"}
    sequence(:username) {|n| "username#{n}"}
    sequence(:email) {|n| "test#{n}@email.com"}
    password { "123456asdf" }
  end
end
