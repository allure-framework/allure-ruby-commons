# frozen_string_literal: true

require_relative "../spec_helper"

describe Allure do
  before do
    Allure.configure { |conf| conf.output_dir = "allure/integration" }
    lifecycle = Allure.lifecycle

    lifecycle.start_test_container(Allure::TestResultContainer.new(name: "Result container"))
    lifecycle.start_prepare_fixture(Allure::FixtureResult.new(name: "Before"))
    lifecycle.update_fixture { |fix| fix.status = Allure::Status::PASSED }
    lifecycle.stop_fixture

    lifecycle.start_test_case(Allure::TestResult.new(name: "Some scenario", full_name: "feature: Some scenario"))
    lifecycle.start_test_step(Allure::StepResult.new(name: "Some step"))
    lifecycle.update_test_step do |step|
      step.status = Allure::Status::FAILED
      step.status_details.message = "Fuuu, I failed"
      step.status_details.trace = "I failed because, so sad"
    end
    lifecycle.stop_test_step
    lifecycle.update_test_case do |test_case|
      test_case.status = Allure::Status::FAILED
      test_case.status_details.message = "Fuuu, I failed"
      test_case.status_details.trace = "I failed because, so sad"
    end
    lifecycle.stop_test_case
    lifecycle.start_tear_down_fixture(Allure::FixtureResult.new(name: "After"))
    lifecycle.update_fixture { |fix| fix.status = Allure::Status::PASSED }
    lifecycle.stop_fixture

    lifecycle.stop_test_container
  end

  it "generate valid json", skip: true do
    # TODO: add check that allure cli can parse full report
  end
end
