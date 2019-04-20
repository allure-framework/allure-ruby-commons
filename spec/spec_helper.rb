# frozen_string_literal: true

require "pry"
require "rspec"
require "allure_ruby_commons"

Allure.configure { |config| config.output_dir = "allure-results" }

def start_test_container(lifecycle, name)
  lifecycle.start_test_container(Allure::TestResultContainer.new(name: name))
end

def start_fixture(lifecycle, name, type)
  lifecycle.public_send("start_#{type}_fixture", Allure::FixtureResult.new(name: name))
end

def add_fixture(lifecycle, name, type)
  fixture_result = lifecycle.public_send("start_#{type}_fixture", Allure::FixtureResult.new(name: name))
  lifecycle.update_fixture { |fixture| fixture.status = Allure::Status::PASSED }
  lifecycle.stop_fixture

  fixture_result
end

def start_test_case(lifecycle, **options)
  lifecycle.start_test_case(Allure::TestResult.new(**options))
end

def start_test_step(lifecycle, **options)
  lifecycle.start_test_step(Allure::StepResult.new(**options))
end
