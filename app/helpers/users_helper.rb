module UsersHelper
  include ConstantsHelper
  def valid_email_addresses? email_addresses
    result={}

    # nil or empty
    if ((email_addresses.nil?) || (email_addresses.empty?))
      result[:valid]=false
      result[:email]="Please enter email addresses."
      return result
    end

    split_email_addresses = email_addresses.split(",")
    split_email_addresses.each do |email|
      unless valid_email?(email)
        result[:valid]=false
        result[:email]="Please verify the format of the email addresses."
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
