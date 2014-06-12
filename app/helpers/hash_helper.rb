module HashHelper
  def copy_hash(from, to)
    from.each do |key, value|
      to[key] = value
    end
  end
  
end