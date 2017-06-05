FactoryGirl.define do
  factory :tag do
    sequence(:name) { Faker::App.unique.name }
  end
end
