require 'rubygems'
require "rails"
require "active_resource"
require "active_record"
require "action_pack"
require "action_controller"
require File.join(File.dirname(__FILE__), '/../lib/barback.rb')
require File.join(File.dirname(__FILE__), '/../lib/handlebars_string.rb')
require File.join(File.dirname(__FILE__), '/../lib/routing.rb')
require "rspec-rails"

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "#{root}/db/barback.db")

include Barback

module Testing
  class Application < Rails::Application; end
end

class Widget
  include Barback
  attr_accessor :id
  def self.include_root_in_json?; true; end
  def handlebars_methods; [:id]; end
end

class Gadget
  include Barback
  attr_accessor :id, :to_param
  def self.include_root_in_json?; true; end
end
