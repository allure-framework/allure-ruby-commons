# frozen_string_literal: true

module Allure
  class AllureLifecycle
    # Start test result container
    # @param [Allure::TestResultContainer] test_result_container
    # @return [Allure::TestResultContainer]
    def start_test_container(test_result_container)
      test_result_container.start = Util.timestamp
      @current_test_result_container = test_result_container
    end

    def update_test_container
      unless @current_test_result_container
        raise Exception.new("Could not update test container, no container is running.")
      end

      yield(@current_test_result_container)
    end

    def stop_test_container
      unless @current_test_result_container
        raise Exception.new("Could not stop test container, no container is running.")
      end

      @current_test_result_container.stop = Util.timestamp
      file_writer.write_test_result_container(@current_test_result_container)
      clear_current_test_container
    end

    # Starts test case
    # @param [Allure::TestResult] test_result
    # @return [Allure::TestResult]
    def start_test_case(test_result)
      unless @current_test_result_container
        raise Exception.new("Could not start test case, test container is not started")
      end

      test_result.start = Util.timestamp
      test_result.stage = Stage::RUNNING
      @current_test_result_container.children.push(test_result.uuid)
      @current_test_case = test_result
    end

    def update_test_case
      raise Exception.new("Could not update test case, no test case running") unless @current_test_case

      yield(@current_test_case)
    end

    def stop_test_case
      raise Exception.new("Could not stop test case, no test case is running") unless @current_test_case

      @current_test_case.stop = Util.timestamp
      @current_test_case.stage = Stage::FINISHED
      file_writer.write_test_result(@current_test_case)
      clear_current_test_case
    end

    # Starts test step
    # @param [Allure::StepResult] step_result
    # @return [Allure]
    def start_test_step(step_result)
      raise Exception.new("Could not start test step, no test case is running") unless @current_test_case

      step_result.start = Util.timestamp
      step_result.stage = Stage::RUNNING
      @current_test_case.steps.push(step_result)
      @current_test_step = step_result
    end

    def update_test_step
      raise Exception.new("Could not update test step, no step is running") unless @current_test_step

      yield(@current_test_step)
    end

    def stop_test_step
      raise Exception.new("Could not stop test step, no step is running") unless @current_test_step

      @current_test_step.stop = Util.timestamp
      @current_test_step.stage = Stage::FINISHED
      clear_current_test_step
    end

    # Start prepare fixture
    # @param [Allure::FixtureResult] fixture_result
    # @return [Allure::FixtureResult]
    def start_prepare_fixture(fixture_result)
      start_fixture(fixture_result)
      @current_test_result_container.befores.push(fixture_result)
      @current_fixture = fixture_result
    end

    # Start tear down fixture
    # @param [Allure::FixtureResult] fixture_result
    # @return [Allure::FixtureResult]
    def start_tear_down_fixture(fixture_result)
      start_fixture(fixture_result)
      @current_test_result_container.afters.push(fixture_result)
      @current_fixture = fixture_result
    end

    # Start fixture
    # @param [Allure::FixtureResult] fixture_result
    # @return [Allure::FixtureResult]
    def start_fixture(fixture_result)
      unless @current_test_result_container
        raise Exception.new("Could not start fixture, test container is not started")
      end

      fixture_result.start = Util.timestamp
      fixture_result.stage = Stage::RUNNING
    end

    def update_fixture
      raise Exception.new("Could not update fixture, fixture is not started") unless @current_fixture

      yield(@current_fixture)
    end

    def stop_fixture
      raise Exception.new("Could not stop fixture, fixture is not started") unless @current_fixture

      @current_fixture.stop = Util.timestamp
      @current_fixture.stage = Stage::FINISHED
      clear_current_fixture
    end

    private

    def file_writer
      @file_writer ||= FileWriter.new
    end

    def clear_current_test_container
      @current_test_result_container = nil
    end

    def clear_current_test_case
      @current_test_case = nil
    end

    def clear_current_test_step
      @current_test_step = nil
    end

    def clear_current_fixture
      @current_fixture = nil
    end
  end
end
