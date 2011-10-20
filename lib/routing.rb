# Monkeypatch to add support for handlebars templates

class ActionDispatch::Routing::RouteSet::Generator
  silence_warnings do
    PARAMETERIZE = {
      :parameterize => lambda do |name, value|
        if name == :controller
          value
        elsif value.respond_to?(:handlebars?)
          value.to_param.sub(".", "}_{")
        elsif value.is_a?(Array)
          value.map { |v| Rack::Mount::Utils.escape_uri(v.to_param) }.join('/')
        else
          return nil unless param = value.to_param
          param.split('/').map { |v| Rack::Mount::Utils.escape_uri(v) }.join("/")
        end
      end
    }
  end

  # for actionpack 3.0
  # def opts
  #   puts "opts"
  #   parameterize = lambda do |name, value|
  #     puts name
  #     if name == :controller
  #       value
  #     elsif value.respond_to?(:handlebars?)
  #       value.to_param.sub(".", "}_{")
  #     elsif value.is_a?(Array)
  #       value.map { |v| Rack::Mount::Utils.escape_uri(v.to_param) }.join('/')
  #     else
  #       return nil unless param = value.to_param
  #       param.split('/').map { |v| Rack::Mount::Utils.escape_uri(v) }.join("/")
  #     end
  #   end
  #   {:parameterize => parameterize}
  # end
end

ActionDispatch::Routing::RouteSet.class_eval do
  def url_for_with_handlebars(*args)
    url_for_without_handlebars(*args).gsub("}_{", ".").gsub(/%7B%7B([^%]+)(\.[^%]+)?%7D%7D/, '{{\1\2}}')
  end

  alias_method_chain :url_for, :handlebars
end
