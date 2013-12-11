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

    split_email_addresses = email_addresses.split(",")
    split_email_addresses.each do |email|
      unless valid_email?(email)
        result[:valid]=false
        result[:email]=I18n.t('invitations.form.errors.email_format')
        return result
      end
    end
    result[:valid]=true
    return result
  end

  def valid_email? email_address
    result = email_address=~ConstantsHelper::EMAIL_REGEX
    return false if result.nil?
    true
  end
end
