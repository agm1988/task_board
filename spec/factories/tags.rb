FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "#{Faker::App.name}_#{n}" }
  end
end
