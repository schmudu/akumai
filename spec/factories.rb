FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "michael_#{n}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"
    superuser false
  end

  factory :role do
    program_id 1
    user_id 1
    level 0
  end

  factory :program do
    sequence(:name) { |n| "TRIO Program UCSD_#{n}" }
  end
end