FactoryGirl.define do
  factory :report do
    user nil
    title "MyString"
  end

  trait :reported do
    status 1
  end
end
