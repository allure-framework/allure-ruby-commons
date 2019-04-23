# frozen_string_literal: true

require_relative "../downloader"

describe Allure do
  let(:lifecycle) { Allure.lifecycle }

  before(:all) do
    Allure.configure { |conf| conf.output_dir = "reports/allure-results/integration" }
  end

  before do
    image = File.new(File.join(Dir.pwd, "spec/images/ruby-logo.png"))

    start_test_container(lifecycle, "Result Container")
    add_fixture(lifecycle, "Before", "prepare")

    start_test_case(lifecycle, name: "Some scenario", full_name: "feature: Some scenario")
    start_test_step(lifecycle, name: "Some step")

    lifecycle.update_test_step do |step|
      step.status = Allure::Status::FAILED
      step.status_details.message = "Fuuu, I failed"
      step.status_details.trace = "I failed because I cought an exception to the knee"
    end

    lifecycle.attachment(name: "Test Attachment", source: "string attachment", type: Allure::ContentType::TXT)

    lifecycle.stop_test_step

    lifecycle.update_test_case do |tc|
      tc.status = Allure::Status::FAILED
      tc.status_details.message = "Fuuu, I failed"
      tc.status_details.trace = "I failed because I cought an exception to the knee"
    end

    lifecycle.attachment(name: "Test Attachment", source: image, type: Allure::ContentType::PNG)

    lifecycle.stop_test_case

    add_fixture(lifecycle, "After", "tear_down")

    lifecycle.stop_test_container
  end

  it "generate valid json", integration: true do
    allure_cli = Allure.allure_bin
    expect(`#{allure_cli} generate -c #{Allure::Config.output_dir} -o reports/allure-report`.chomp).to(
      eq("Report successfully generated to reports/allure-report"),
    )
  end
end
