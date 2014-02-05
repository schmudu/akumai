module UsersHelper
  include ConstantsHelper
  def valid_email_addresses? email_addresses
    result={}

    # nil or empty
    if ((email_addresses == I18n.t('invitations.form.prompt.default_email')) || (email_addresses.nil?) || (email_addresses.blank?))
      result[:valid]=false
      result[:error_email]=I18n.t('invitations.form.errors.email_blank')
      return result
    end

    split_email_addresses = clean_and_split_email_address_to_a(email_addresses)

    # validate email expression
    split_email_addresses.each do |email|
      unless valid_email?(email)
        result[:valid]=false
        result[:error_email]=I18n.t('invitations.form.errors.email_format')
        return result
      end
    end

    # validate duplicates
    if duplicate_email_addresses? split_email_addresses
      result[:valid]=false
      result[:error_email]=I18n.t('invitations.form.errors.duplicate_email_address')
      return result
    end

    result[:valid]=true
    result[:emails]=split_email_addresses
    return result
  end

  def valid_email? email_address
    result = email_address=~ConstantsHelper::EMAIL_REGEX
    return false if result.nil?
    true
  end

  def user_level_to_s user_level_constant
    # returns the user level in the form of a string
    return "Superuser" if user_level_constant == ConstantsHelper::ROLE_LEVEL_SUPERUSER.to_s
    return "Admin" if user_level_constant == ConstantsHelper::ROLE_LEVEL_ADMIN.to_s
    return "Staff" if user_level_constant == ConstantsHelper::ROLE_LEVEL_STAFF.to_s
    return "Student"
  end

  def clean_emails email_addresses
    email_addresses.gsub!("\r\n", "")
    email_addresses.gsub!(" ", "")
  end

  def clean_and_split_email_address_to_a email_addresses
    clean_emails email_addresses
    split_email_addresses = email_addresses.split(",")
  end

  def duplicate_email_addresses? array
    result = array.detect {|e| array.rindex(e) != array.index(e) }
    return true unless result.nil?
    return false
  end
end
