FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    company
    password "password"
    password_confirmation "password"
  end

end
