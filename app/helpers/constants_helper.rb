# any changes here means changes to constants.js
module ConstantsHelper
  # ROLE
  ROLE_LEVEL_STUDENT = 0
  ROLE_LEVEL_STAFF = 1
  ROLE_LEVEL_ADMIN = 2
  ROLE_LEVEL_SUPERUSER = 3

  # INVITATIONS
  INVITATION_STATUS_SETUP_TYPE = 0
  
  # INVITE
  INVITATION_STATUS_CREATED = 0
  INVITATION_STATUS_SENT = 1
  INVITATION_STATUS_ACCEPTED = 2
  INVITATION_STATUS_REJECTED = 3
  INVITATION_STATUS_EXPIRED = 4
  EMAIL_REGEX = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  INVITATION_SENDER_EMAIL = "notifications@trios.com"
end