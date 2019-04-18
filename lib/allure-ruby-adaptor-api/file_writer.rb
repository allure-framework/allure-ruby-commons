# frozen_string_literal: true

module Allure
  class FileWriter
    TEST_RESULT_SUFFIX = "-result.json"
    TEST_RESULT_CONTAINER_SUFFIX = "-container.json"
    ATTACHMENT_FILE_SUFFIX = "-attachment"

    # Write test result
    # @param [Allure::TestResult] test_result
    # @return [void]
    def write_test_result(test_result)
      write(
        name: "#{test_result.uuid}#{TEST_RESULT_SUFFIX}",
        source: test_result.to_json,
      )
    end

    # Write test result container
    # @param [Allure::TestResultContainer] test_container_result
    # @return [void]
    def write_test_result_container(test_container_result)
      write(
        name: "#{test_container_result.uuid}#{TEST_RESULT_CONTAINER_SUFFIX}",
        source: test_container_result.to_json,
      )
    end

    private

    # Write string to file
    # @param [String] name
    # @param [String] source
    # @return [void]
    def write(name:, source:)
      filename = File.join(output_dir, name)
      File.open(filename, "w") { |file| file.write(source) }
    end

    def output_dir
      @output_dir ||= FileUtils.mkpath(Allure::Config.output_dir).first
    end
  end
end
