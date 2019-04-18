# frozen_string_literal: true

require_relative "../spec_helper"

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }

  context "without exceptions" do
    before do
      @result_container = Allure::TestResultContainer.new
      @test_case = Allure::TestResult.new
      lifecycle.start_test_container(@result_container)
      lifecycle.start_test_case(@test_case)

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

  context "raises exception" do
    it "no running container" do
      expect { lifecycle.start_test_case(Allure::TestResult.new) }.to raise_error(/Could not start test case/)
    end

    it "no running test" do
      lifecycle.start_test_container(Allure::TestResultContainer.new)

      aggregate_failures "Should raise exception" do
        expect { lifecycle.update_test_case { |t| t.full_name = "Test" } }.to raise_error(/Could not update test/)
        expect { lifecycle.stop_test_case }.to raise_error(/Could not stop test/)
      end
    end
  end
end
