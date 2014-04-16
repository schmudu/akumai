require_relative '../helpers/constants_helper'
require 'module_failure_job'

class MailInviteUserUnregisteredJob
  # TODO - Rails cannot find this file
  #extend FailureJob

  @queue = :mail

  def self.perform(id)
    invite = get_resource id
    InviteMailer.send_user_unregistered(invite).deliver
  end

  def self.get_resource id
    Invite.find_by_id id
  end
end