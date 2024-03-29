# any changes here means changes to constants.js
module ConstantsHelper
  # ROLE
  ROLE_LEVEL_NO_ROLE = -1 
  ROLE_LEVEL_STUDENT = 0
  ROLE_LEVEL_STAFF = 1
  ROLE_LEVEL_ADMIN = 2
  ROLE_LEVEL_SUPERUSER = 3

  # INVITATIONS
  INVITATION_STATUS_SETUP_TYPE = 0
  INVITATION_STATUS_SETUP_ADDRESS = 1
  INVITATION_STATUS_SETUP_REVIEW = 2
  INVITATION_NAME_DEFAULT = "Enter invitation name"
  INVITATION_STUDENT_ENTRIES_DEFAULT = 5
  INVITATION_DEFAULT_STUDENT_ID = "Student ID"
  INVITATION_DEFAULT_STUDENT_EMAIL = "Student Email"
  INVITATION_DEFAULT_NON_STUDENT_EMAIL = "jake@sample.edu, samantha@something.org"
  
  # INVITE
  INVITE_STATUS_CREATED = 0
  INVITE_STATUS_SENT = 1
  INVITE_STATUS_ACCEPTED = 2
  INVITE_STATUS_REJECTED = 3
  INVITE_STATUS_EXPIRED = 4
  EMAIL_REGEX = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  INVITE_SENDER_EMAIL = "notifications@trios.com"
  INVITE_DEFAULT_EMAIL = "Enter your email"
  INVITE_DEFAULT_CODE = "Invite Code"
  INVITE_DEFAULT_STUDENT_ID = "Program Student ID"

  # Resque
  MAX_NUMBER_OF_ATTEMPTS = 5

  # COURSES
  COURSE_NAME_STORE = {
    "alg" => "algebra",
    "i" => "1",
    "ii" => "2",
    "iii" => "3",
    "iiii" => "4",
    "iv" => "4",
    "iiiii" => "5",
    "v" => "5"
  }
end