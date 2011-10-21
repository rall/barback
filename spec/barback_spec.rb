require "spec_helper"

describe Barback do
  context "a plain ruby class with an as_json method" do
    let(:widget) { Widget.handlebars_object }
    let(:widget_collection) { Widget.handlebars_collection }
    let(:widget_collection_with_custom_iterator) { Widget.handlebars_collection("wibble") }
    let(:widget_with_path) { Widget.handlebars_object("foo") }

    describe "#handlebars_object" do
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

    end

    describe "#handlebars_collection" do
      it "returns a one item array" do
        widget_collection.should be_instance_of Array
        widget_collection.length.should == 1
      end

      it "should contain a handlebars object with path set to 'this', the label for scope in handlebars iterators" do
        widget_collection.first.to_param.should == "{{this.to_param}}"
      end

      context "the iterator name that goes into a {{#each <iterator>}} statement" do
        it "should default to the plural of the objects class" do
          widget_collection.first.iterator.should == "widgets"
        end

        it "should be passed through to the contained object when set explicitly" do
          widget_collection_with_custom_iterator.first.iterator.should == "wibble"
        end
      end
    end
  end

  context "an activerecord model" do
    let(:sprocket) { Sprocket.handlebars_object }
    let(:flange) { Flange.handlebars_object }

    it "creates handlebars representations of properties" do
      flange.foo.should == "{{foo}}"
    end

    context "one-to-many relations" do
      it "creates handlebars collection" do
        sprocket.flanges.should be_instance_of Array
        sprocket.flanges.length.should == 1
      end

      it "creates a handlebars object with 'this' scope" do
        sprocket.flanges.first.foo.should == "{{this.foo}}"
      end
    end

  end

  context "an activeresource model" do

  end
end
