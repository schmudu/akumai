FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "michael_#{n}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"
    superuser false
  end

  factory :program do
    sequence(:name) { |n| "TRIO Program UCSD_#{n}" }
  end
end