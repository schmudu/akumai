class String
  def is_numeral?
    # TODO: Need to handle more complex numerals
    # matches lowercase numeral
    res_single = self.match(/^i+$/)
    return false if res_single.nil?
    return true
  end
end