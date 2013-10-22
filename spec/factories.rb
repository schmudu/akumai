FactoryGirl.define do
  factory :user do
    email    "michael@example.com"
    password "foobar123"
    password_confirmation "foobar123"
  end
end