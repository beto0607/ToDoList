FactoryBot.define do
  factory :comment do
    description { "A comment" }
    user
    list
  end
end
