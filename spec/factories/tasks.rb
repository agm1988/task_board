# frozen_string_literal: true

FactoryGirl.define do
  factory :task do
    sequence(:title) { Faker::Lorem.sentence(4) }
    sequence(:description) { Faker::Lorem.sentence(10) }
    tags { build_list :tag, rand(1..2) }
  end
end
