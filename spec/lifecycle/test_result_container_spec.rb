# frozen_string_literal: true

require "logger"

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }
  let(:logger) { double("Logger") }

  before do
    @result_container = start_test_container(lifecycle, "Test Container")
    allow(Allure::FileWriter).to receive(:new).and_return(file_writer)
    allow(Logger).to receive(:new).and_return(logger)
  end

  it "starts test result container" do
    expect(@result_container.start).to be_a(Numeric)
  end

  it "updates test result container" do
    lifecycle.update_test_container { |container| container.description = "Test description" }

    expect(@result_container.description).to eq("Test description")
  end

  it "stops test result container" do
    allow(file_writer).to receive(:write_test_result_container)
    lifecycle.stop_test_container

    expect(@result_container.stop).to be_a(Numeric)
  end

  it "calls file writer on stop" do
    expect(file_writer).to receive(:write_test_result_container).with(@result_container)

    lifecycle.stop_test_container
  end

  it "logs error when stopping or updating test result container" do
    allow(file_writer).to receive(:write_test_result_container)

    expect(logger).to receive(:error).with(/Could not update test container/)
    expect(logger).to receive(:error).with(/Could not stop test container/)

    lifecycle.stop_test_container

    lifecycle.update_test_container { |c| c.description = "Test" }
    lifecycle.stop_test_container
  end
end
