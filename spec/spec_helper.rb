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

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'sprockets'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'flanges'")
ActiveRecord::Base.connection.create_table(:sprockets) do |t|
    t.string :foo, :bar
end
ActiveRecord::Base.connection.create_table(:flanges) do |t|
    t.string :foo, :bar
    t.integer :sprocket_id
end

class Sprocket < ActiveRecord::Base
  has_many :flanges
end

class Flange < ActiveRecord::Base
  belongs_to :sprocket
end

