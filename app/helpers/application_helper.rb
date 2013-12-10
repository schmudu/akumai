module ApplicationHelper
  # Returns full title on a per-page basis
  def full_title(page_title)
    base_title = "TRIO"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end 

  def generate_hash
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    return (0...50).map{ o[rand(o.length)] }.join
  end
end
