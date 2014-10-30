require 'spec_helper'
require 'tempfile'

describe AllureRubyAdaptorApi do
  let(:builder) { AllureRubyAdaptorApi::Builder }

  it "should build xml report" do

    builder.start_suite "some_suite", :severity => :normal
    builder.start_test "some_suite", "some_test", :feature => "Some feature"
    builder.start_step "some_suite", "some_test", "first step"
    builder.stop_step "some_suite", "some_test", "first step"
    builder.start_step "some_suite", "some_test", "second step"
    builder.stop_step "some_suite", "some_test", "second step"
    builder.start_step "some_suite", "some_test", "third step"
    builder.stop_step "some_suite", "some_test", "third step", :failed
    builder.stop_test "some_suite", "some_test", :status => :broken, :exception => Exception.new("some error")
    builder.stop_suite "some_suite"

    builder.start_suite "some_empty_suite"
    builder.stop_suite "some_empty_suite"

    builder.build! {|suite, xml|
      xml.should_not be_empty
      xml.should include("<ns2:test-suite")
      xml.should include("<title>some_suite</title>")
      xml
    }
  end
end
