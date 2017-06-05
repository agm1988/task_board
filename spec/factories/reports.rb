FactoryGirl.define do
  factory :report do
    sequence(:title) { Faker::Lorem.sentence }
    user
    tasks { build_list :task, 2 }
  end

  trait :reported do
    status 1
  end
end
