# frozen_string_literal: true

require_relative "spec_helper"

describe Allure::FileWriter do
  let(:file_writer) { Allure::FileWriter.new }

  it "writes test result container" do
    test_result_container = Allure::TestResultContainer.new
    json_file = File.join(Allure::Config.output_dir, "#{test_result_container.uuid}-container.json")
    file_writer.write_test_result_container(test_result_container)

    expect(File.exist?(json_file)).to be_truthy, "Expected file to exist"
  end

  it "writes test result container" do
    test_result = Allure::TestResult.new
    json_file = File.join(Allure::Config.output_dir, "#{test_result.uuid}-result.json")
    file_writer.write_test_result(test_result)

    expect(File.exist?(json_file)).to be_truthy, "Expected file to exist"
  end
end
