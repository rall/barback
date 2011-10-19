require "spec_helper"

describe HandlebarsString do
  subject { HandlebarsString.new "{{foo}}" }

  it "should identify with a handlebars? method" do
    subject.should be_handlebars
  end

  it "return an html_safe version of itself with three curlies instead of two" do
    subject.html_safe.should == "{{{foo}}}"
  end

  it "return a naked version of itself with no curlies" do
    subject.naked.should == "foo"
  end
end
