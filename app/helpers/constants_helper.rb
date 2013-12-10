# any changes here means changes to constants.js
module ConstantsHelper
  ROLE_LEVEL_STUDENT = 0
  ROLE_LEVEL_STAFF = 1
  ROLE_LEVEL_ADMIN = 2
  ROLE_LEVEL_SUPERUSER = 3
  USER_INVITATION_PROGRAM_DEFAULT = "Please select a program."
  USER_INVITATION_PROGRAM_DEFAULT_SELECTION = "Select Program"

  EMAIL_REGEX = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
end