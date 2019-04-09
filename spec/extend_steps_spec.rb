# frozen_string_literal: true

require_relative("spec_helper")
require "tempfile"

describe AllureRubyAdaptorApi do
  let(:builder) { AllureRubyAdaptorApi::Builder }

  before(:each) do
    builder.start_suite("some suite")
    builder.start_test("some test")
  end

  it "builds xml report" do
    builder.start_step("some step 1")
    builder.stop_step
    builder.stop_test(AllureRubyAdaptorApi::Result.new(:passed))
    xml = builder.stop_suite

    aggregate_failures "Expected xml params not found" do
      expect(xml).to_not(be_empty)
      expect(xml).to(include("<ns2:test-suite"))
      expect(xml).to(include("<title>some suite</title>"))
      expect(xml).to(include("<title>some test</title>"))
      expect(xml).to(include("<title>some step 1</title>"))
    end
  end

  it "adds exception" do
    builder.start_step("some step 2")
    builder.stop_step(:failed)
    builder.stop_test(AllureRubyAdaptorApi::Result.new(:broken, Exception.new("some error")))
    xml = builder.stop_suite

    aggregate_failures "Expected xml params not found" do
      expect(xml).to(include("<title>some step 2</title>"))
      expect(xml).to(include("<message>some error</message>"))
    end
  end

  it "adds attachment" do
    builder.start_step("some step 1")
    builder.stop_step
    builder.add_attachment(file: File.new(File.new("spec/images/ruby-logo.png")))
    builder.stop_test(AllureRubyAdaptorApi::Result.new(:passed))
    xml = builder.stop_suite

    aggregate_failures "Expected xml params not found" do
      expect(xml).to(include('title="ruby-logo.png"'))
      expect(xml).to(include('type="image/png"'))
    end
  end
end
