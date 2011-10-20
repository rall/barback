require "spec_helper"

describe Barback do
  context "a plain ruby class with an as_json method" do
    let(:widget) { Widget.handlebars_object }
    let(:widget_with_path) { Widget.handlebars_object("foo") }

    it "should have handlebars? method" do
      widget.should be_handlebars
    end

    it "should have a to_param method" do
      widget.to_param.should == "{{to_param}}"
    end

    it "should have a to_param method with a path" do
      widget_with_path.to_param.should == "{{foo.to_param}}"
    end

    context "the naked method" do
      it "removes the curlies" do
        widget.naked.should == "widget"
      end

      it "removes the curlies from the path, when that is set" do
        widget_with_path.naked.should == "foo"
      end
    end

    it "should have a default plural iterator name for handlebars loops" do
      widget.iterator.should == "widgets"
    end

    it "should allow the iterator name to be explicitly set" do
      Widget.handlebars_object(nil, :iterator => "foo").iterator.should == "foo"
    end
  end

  context "an activerecord model" do

  end

  context "an activeresource model" do

  end
end
