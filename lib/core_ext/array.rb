class Array
  def map_send(*args)
    map { |x| x.send(*args) }
  end
end