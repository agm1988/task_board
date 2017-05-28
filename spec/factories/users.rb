FactoryGirl.define do
  factory :user do
    sequence(:first_name) { Faker::Name.first_name }
    sequence(:last_name) { Faker::Name.last_name }
    sequence(:email)    { |n| "user#{n}@example.com" }
    sequence(:nickname)    { |n| "#{Faker::Internet.user_name}00#{n}" }
  end

  trait :admin do
    is_admin true
  end
end
