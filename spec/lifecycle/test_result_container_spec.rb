# frozen_string_literal: true

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }

  before do
    @result_container = Allure::TestResultContainer.new
    lifecycle.start_test_container(@result_container)
    allow(Allure::FileWriter).to receive(:new).and_return(file_writer)
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

  it "raises exception when stopping test result container" do
    allow(file_writer).to receive(:write_test_result_container)
    lifecycle.stop_test_container

    aggregate_failures "Should raise exception" do
      expect { lifecycle.stop_test_container }.to raise_error(/Could not stop test container/)
      expect { lifecycle.update_test_container { |c| c.description = "Test" } }.to raise_error(
        /Could not update test container/,
      )
    end
  end
end
