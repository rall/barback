require 'spec_helper'

module Testing
  class Application < Rails::Application; end
end

class WidgetsController < ActionController::Base; end

class Widget
  include Barback
  attr_accessor :to_param, :id
  def self.include_root_in_json?; true; end
  def handlebars_methods; [:to_param, :id]; end
end

class Gadget
  include Barback
  attr_accessor :to_param, :id
  def self.include_root_in_json?; true; end
  def handlebars_methods; [:to_param]; end
end

describe "generating urls for handlebars" do
  let(:widget) { Widget.handlebars_object }
  let(:gadget) { Gadget.handlebars_object("gadget") }
  let(:real_gadget) { Gadget.new.tap { |g| g.to_param = "some_gadget_id" } }
  let(:app) { ActionDispatch::Integration::Session.new(Rails.application) }

  context "and routes" do
    before do
      Testing::Application.routes.clear!
      Testing::Application.routes.draw do
        resources :widgets do
          resources :gadgets
        end
        match "another_route/:widget_id" => 'widgets#special_action', :as => 'another_route'
        resources :gadgets do
          resources :widgets
        end
      end
    end

    after do
      Rails.application.reload_routes!
    end

    it "should return the path for a named route" do
      app.widget_path(widget).should == "/widgets/{{to_param}}"
    end

    it "should return the path for a specific route" do
      app.another_route_path(widget).should == "/another_route/{{to_param}}"
    end

    it "should return the path for a nested route when a child" do
      app.gadget_widget_path(real_gadget, widget).should == "/gadgets/some_gadget_id/widgets/{{to_param}}"
    end

    xit "should return the path with a query string" do
      app.gadget_path(real_gadget, :widget_id => widget.id).should == "/gadgets/some_gadget_id?widget_id={{id}}"
    end

    it "should return the path for a nested route when a container" do
      app.widget_gadgets_path(widget).should == "/widgets/{{to_param}}/gadgets"
    end

    it "should nest two templates in a path" do
      app.gadget_widget_path(gadget, widget).should == "/gadgets/{{gadget.to_param}}/widgets/{{to_param}}"
    end
  end
end
