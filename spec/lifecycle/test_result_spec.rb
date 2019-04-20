# frozen_string_literal: true

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }
  let(:logger) { double("Logger") }

  before do
    allow(Logger).to receive(:new).and_return(logger)
  end

  context "without exceptions" do
    before do
      @result_container = start_test_container(lifecycle, "Test Container")
      @test_case = start_test_case(lifecycle, name: "Test Case")

      allow(Allure::FileWriter).to receive(:new).and_return(file_writer)
    end

    it "starts test case" do
      aggregate_failures "Should start test and add to test container" do
        expect(@test_case.start).to be_a(Numeric)
        expect(@test_case.stage).to eq(Allure::Stage::RUNNING)
        expect(@result_container.children.last).to eq(@test_case.uuid)
      end
    end

    it "updates test case" do
      lifecycle.update_test_case { |test| test.full_name = "Full name: Test" }

      expect(@test_case.full_name).to eq("Full name: Test")
    end

    it "stops test" do
      allow(file_writer).to receive(:write_test_result)

      lifecycle.stop_test_case

      aggregate_failures "Should update parameters" do
        expect(@test_case.stop).to be_a(Numeric)
        expect(@test_case.stage).to eq(Allure::Stage::FINISHED)
      end
    end

    it "calls file writer on stop" do
      expect(file_writer).to receive(:write_test_result).with(@test_case)

      lifecycle.stop_test_case
    end
  end

  context "logs error" do
    it "no running container" do
      expect(logger).to receive(:error).with(/Could not start test case/)

      start_test_case(lifecycle, name: "Test Case")
    end

    it "no running test" do
      start_test_container(lifecycle, "Test Container")

      expect(logger).to receive(:error).with(/Could not update test/)
      expect(logger).to receive(:error).with(/Could not stop test/)

      lifecycle.update_test_case { |t| t.full_name = "Test" }
      lifecycle.stop_test_case
    end
  end
end
