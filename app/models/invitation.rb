class Invitation < ActiveRecord::Base
  belongs_to :user
  has_many :recipients, class_name: "User", foreign_key: "invitation_recipient_id"
end
