FactoryBot.define do
  factory :list do
    sequence(:title) {|n| "New Rails project ##{n}"}
    description { "New project based in Rails" }
    due_date { "2019-06-30 23:17:00" }
    user
  end
end
