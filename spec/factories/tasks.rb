# frozen_string_literal: true

FactoryGirl.define do
  factory :task do
    title 'MyString'
    description 'MyText'
    tags { build_list :tag, 2 }
  end
end
