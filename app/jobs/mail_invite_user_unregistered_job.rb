class MailInviteUserUnregisteredJob
  @queue = :mail
  def self.perform(invite_id)
    invite = Invite.find_by_id(invite_id)
    InviteMailer.send_user_unregistered(invite).deliver
  end

  def self.after_perform(invite_id)
    logger.info "\n\nAFTER PERFORM==="
  end
end