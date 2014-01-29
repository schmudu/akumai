require_relative '../app/helpers/constants_helper'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "michael_#{n}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"
    superuser false
  end

  factory :invitation do
    program_id 1
    user_level ConstantsHelper::ROLE_LEVEL_STUDENT 
    status ConstantsHelper::INVITATION_STATUS_CREATED
    recipient_emails ""
  end

  factory :role do
    program_id 1
    user_id 1
    level ConstantsHelper::ROLE_LEVEL_STUDENT 
    sequence(:student_id) { |n| "a00#{n}" }
  end

  factory :program do
    sequence(:name) { |n| "TRIO Program UCSD_#{n}" }
  end
end