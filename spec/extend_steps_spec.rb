# frozen_string_literal: true

require_relative "spec_helper"
require "tempfile"

describe AllureRubyAdaptorApi do
  let(:builder) { AllureRubyAdaptorApi::Builder }

  it "should build xml report" do
    builder.start_suite "some_suite"
    builder.start_test "some_test"
    builder.start_step "some step 1"
    builder.stop_step
    builder.start_step "some step 2"
    builder.stop_step
    builder.start_step "some step 3"
    builder.stop_step :failed
    builder.stop_test AllureRubyAdaptorApi::Result.new(:broken, Exception.new("some error"))
    builder.stop_suite

    builder.start_suite "some empty suite"
    builder.stop_suite

    builder.build! { |suite, xml|
      expect(xml).to_not be_empty
      expect(xml).to include("<ns2:test-suite")
      expect(xml).to include("<title>some_suite</title>")
      xml
    }
  end
end
