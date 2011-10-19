class HandlebarsString < String
  def handlebars?
    true
  end

  def html_safe
    "{#{to_s}}"
  end

  def naked
    to_s.gsub(/[{}]/,"")
  end
end
