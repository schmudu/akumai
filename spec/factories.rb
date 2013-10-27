FactoryGirl.define do
  factory :user do
    email    "michael@example.com"
    password "foobar123"
    password_confirmation "foobar123"
    superuser false
  end

  factory :program do
    name    "TRIO Program UCSD"
  end
end