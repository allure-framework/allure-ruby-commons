# frozen_string_literal: true

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }

  context "without exceptions" do
    before do
      @result_container = Allure::TestResultContainer.new
      @test_case = Allure::TestResult.new(name: "Test case", full_name: "Full name")
      @test_step = Allure::StepResult.new(name: "Step name", descrption: "step description")
      lifecycle.start_test_container(@result_container)
      lifecycle.start_test_case(@test_case)
      lifecycle.start_test_step(@test_step)

      allow(Allure::FileWriter).to receive(:new).and_return(file_writer)
    end

    it "starts test step" do
      lifecycle.start_test_step(@test_step)

      aggregate_failures "should start test step and add to test case" do
        expect(@test_step.start).to be_a(Numeric)
        expect(@test_case.steps.last).to eq(@test_step)
      end
    end

    it "updates test step" do
      lifecycle.update_test_step { |step| step.status = Allure::Status::CANCELED }

      expect(@test_step.status).to eq(Allure::Status::CANCELED)
    end

    it "stops test step" do
      lifecycle.stop_test_step

      aggregate_failures "Should update parameters" do
        expect(@test_step.stop).to be_a(Numeric)
        expect(@test_step.stage).to eq(Allure::Stage::FINISHED)
      end
    end
  end

  context "raises exception" do
    it "no running test case" do
      expect { lifecycle.start_test_step(Allure::StepResult.new) }.to raise_error(/no test case is running/)
    end

    it "no running test step" do
      lifecycle.start_test_container(Allure::TestResultContainer.new)
      lifecycle.start_test_case(Allure::TestResult.new)

      aggregate_failures "should raise exception" do
        expect { lifecycle.update_test_step { |step| step.name = "Test" } }.to raise_error(/no step is running/)
        expect { lifecycle.stop_test_step }.to raise_error(/no step is running/)
      end
    end
  end
end
