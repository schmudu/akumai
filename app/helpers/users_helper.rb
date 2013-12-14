module UsersHelper
  include ConstantsHelper
  def valid_email_addresses? email_addresses
    result={}

    # nil or empty
    if ((email_addresses == I18n.t('invitations.form.prompt.default_email')) || (email_addresses.nil?) || (email_addresses.blank?))
      result[:valid]=false
      result[:email]=I18n.t('invitations.form.errors.email_blank')
      return result
    end

    # clear newlines
    email_addresses.sub!("\r\n", "")
    logger.info("\nEmails:#{email_addresses}")
    split_email_addresses = email_addresses.split(",")
    split_email_addresses.each do |email|
      unless valid_email?(email)
        result[:valid]=false
        result[:email]=I18n.t('invitations.form.errors.email_format')
        return result
      end
    end
    result[:valid]=true
    result[:emails]=split_email_addresses
    return result
  end

  def valid_email? email_address
    result = email_address=~ConstantsHelper::EMAIL_REGEX
    logger.info("\nIn valid_email? email:#{email_address} valid?:#{result}")
    return false if result.nil?
    true
  end

  def user_level user_level_constant
    # returns the user level in the form of a string
    return "superuser" if user_level_constant == ConstantsHelper::ROLE_LEVEL_SUPERUSER
    return "admin" if user_level_constant == ConstantsHelper::ROLE_LEVEL_ADMIN
    return "staff" if user_level_constant == ConstantsHelper::ROLE_LEVEL_STAFF
    return "student"
  end
end
