# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:first_name) { Faker::Name.first_name }
    sequence(:last_name) { Faker::Name.last_name }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:nickname) { |n| "#{Faker::Internet.user_name}00#{n}" }
    work_start_time '10:00'
    password { Faker::Internet.password(8, 16) }
    password_confirmation(&:password)
  end

  trait :admin do
    is_admin true
  end
end
