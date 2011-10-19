require 'rubygems'
require "active_resource"
require "active_record"
require File.join(File.dirname(__FILE__), '/../lib/barback.rb')
include Barback

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "#{root}/db/barback.db")
