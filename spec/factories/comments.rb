FactoryGirl.define do
  factory :comment do
    sequence(:body) { Faker::Lorem.sentence }
  end
end
