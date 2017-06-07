# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    sequence(:body) { Faker::Lorem.sentence }
  end

  trait :needs_notification do
    need_notification true
  end
end
