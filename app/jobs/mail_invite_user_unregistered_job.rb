class MailInviteUserUnregisteredJob
  @queue = :mail
  def self.perform(invite_id)
    invite = Invite.find_by_id(invite_id)
    InviteMailer.send_user_unregistered(invite)
  end
end