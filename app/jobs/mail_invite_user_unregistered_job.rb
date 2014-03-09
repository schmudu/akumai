require_relative '../../app/helpers/constants_helper'
require_relative './module_failure_job'

class MailInviteUserUnregisteredJob
  extend FailureJob

  @queue = :mail

  def self.perform(id)
    invite = get_resource id
    InviteMailer.send_user_unregistered(invite).deliver
  end

  def self.after_perform(id)
    invite = get_resource id
    invite.update_attribute(:status, ConstantsHelper::INVITE_STATUS_SENT)
  end

  def self.get_resource id
    Invite.find_by_id id
  end
end