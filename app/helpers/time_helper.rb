module TimeHelper
  def to_datetime(str, error_message)
    date_time = str.to_datetime

    raise error_message if date_time.nil?
    return date_time
  end
end