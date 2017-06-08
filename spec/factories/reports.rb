# frozen_string_literal: true

FactoryGirl.define do
  factory :report do
    sequence(:title) { Faker::Lorem.sentence(3) }
    user
    tasks { build_list :task, rand(1..3) }
  end

  trait :reported do
    status 1
  end
end
