FactoryGirl.define do
  factory :core_course do
    name "Default Name"
  end

  factory :custom_error do
    resource "Invite"
    comment "Invite #1 is not valid"
  end

  factory :dataset do
  end

  factory :dataset_entry do
  end

  factory :invitation do
    program_id 1
    name "Random Invitation"
    recipient_emails ""
    status ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
    user_level ConstantsHelper::ROLE_LEVEL_STUDENT 
  end

  factory :invite do
    code ""
    email "test@abc.com"
    student_id ""
    user_level ConstantsHelper::ROLE_LEVEL_STAFF
  end

  factory :mapped_course do
    name "Default Name"
  end

  factory :program do
    sequence(:name) { |n| "TRIO Program UCSD_#{n}" }
  end

  factory :role do
    program_id 1
    user_id 1
    level ConstantsHelper::ROLE_LEVEL_STUDENT 
    sequence(:student_id) { |n| "a00#{n}" }
  end

  factory :student_entry do
    email ""
    student_id 1
    saved false
    invitation_id 1
  end

  factory :user do
    sequence(:email) { |n| "michael_#{n}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"
    superuser false
  end
end