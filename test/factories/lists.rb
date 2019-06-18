FactoryBot.define do
  factory :list do
    title { "New Rails project" }
    description { "New project based in Rails" }
    due_date { "2019-06-30 23:17:00" }
    user
  end
end
