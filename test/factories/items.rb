FactoryBot.define do
  factory :item do
    sequence(:title) {|n| "Item ##{n}" }
    description { "Item description." }
    list
  end
end
