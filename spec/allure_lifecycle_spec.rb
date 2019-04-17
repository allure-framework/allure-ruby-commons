# frozen_string_literal: true

require_relative "spec_helper"

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }

  describe "test result container" do
    before do
      @result_container = Allure::TestResultContainer.new
      lifecycle.start_test_container(@result_container)
    end

    it "starts test result container" do
      expect(@result_container.start).to be_a(Numeric)
    end

    it "updates test result container" do
      lifecycle.update_test_container { |container| container.description = "Test description" }
      expect(@result_container.description).to eq("Test description")
    end

    it "stops test result container" do
      lifecycle.stop_test_container
      expect(@result_container.stop).to be_a(Numeric)
    end

    it "raises exception" do
      lifecycle.stop_test_container

      aggregate_failures "Should raise exception" do
        expect { lifecycle.stop_test_container }.to raise_error(/Could not stop test container/)
        expect { lifecycle.update_test_container { |c| c.description = "Test" } }.to raise_error(
          /Could not update test container/,
        )
      end
    end
  end

  describe "test case" do
    context "lifecycle" do
      before do
        @result_container = Allure::TestResultContainer.new
        @test_case = Allure::TestResult.new
        lifecycle.start_test_container(@result_container)
        lifecycle.start_test_case(@test_case)
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
        lifecycle.stop_test_case
        aggregate_failures "Should update parameters" do
          expect(@test_case.stop).to be_a(Numeric)
          expect(@test_case.stage).to eq(Allure::Stage::FINISHED)
        end
      end
    end

    context "exceptions" do
      it "raises no running container exception" do
        expect { lifecycle.start_test_case(Allure::TestResult.new) }.to raise_error(/Could not start test case/)
      end

      it "raises no running test exception" do
        lifecycle.start_test_container(Allure::TestResultContainer.new)

        aggregate_failures "Should raise exception" do
          expect { lifecycle.update_test_case { |t| t.full_name = "Test" } }.to raise_error(/Could not update test/)
          expect { lifecycle.stop_test_case }.to raise_error(/Could not stop test/)
        end
      end
    end
  end

  describe "test step" do
    context "lifecycle" do
      before do
        @result_container = Allure::TestResultContainer.new
        @test_case = Allure::TestResult.new
        @test_step = Allure::StepResult.new
        lifecycle.start_test_container(@result_container)
        lifecycle.start_test_case(@test_case)
        lifecycle.start_test_step(@test_step)
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

    context "exceptions" do
      it "raises no running test case exception" do
        expect { lifecycle.start_test_step(Allure::StepResult.new) }.to raise_error(/no test case is running/)
      end

      it "raises no running test step exception" do
        lifecycle.start_test_container(Allure::TestResultContainer.new)
        lifecycle.start_test_case(Allure::TestResult.new)

        aggregate_failures "should raise exception" do
          expect { lifecycle.update_test_step { |step| step.name = "Test" } }.to raise_error(/no step is running/)
          expect { lifecycle.stop_test_step }.to raise_error(/no step is running/)
        end
      end
    end
  end
end
