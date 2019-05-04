# frozen_string_literal: true

describe "allure-ruby-commons" do
  include_context "lifecycle"

  before(:all) do
    Allure.configure do |conf|
      conf.output_dir = "reports/allure-results/integration"
      conf.issue_link_pattern = "http://jira.com/{}"
      conf.tms_link_pattern = "http://jira.com/{}"
    end
    FileUtils.remove_dir(Allure::Config.output_dir)
  end

  before do
    image = File.new(File.join(Dir.pwd, "spec/images/ruby-logo.png"))

    start_test_container(lifecycle, "Result Container")
    add_fixture(lifecycle, "Before", "prepare")

    start_test_case(lifecycle, name: "Some scenario", full_name: "feature: Some scenario")
    lifecycle.add_link("Custom Link", "http://www.custom-link.com")
    lifecycle.update_test_case do |test_case|
      test_case.links.push(
        Allure::ResultUtils.tms_link("QA-1"),
        Allure::ResultUtils.issue_link("DEV-1"),
      )
      test_case.labels.push(
        Allure::ResultUtils.suite_label("Some scenario"),
        Allure::ResultUtils.severity_label("blocker"),
      )
    end

    start_test_step(lifecycle, name: "Some step")
    lifecycle.update_test_step do |step|
      step.status = Allure::Status::FAILED
      step.status_details.message = "Fuuu, I failed"
      step.status_details.trace = "I failed because I cought an exception to the knee"
    end

    lifecycle.add_attachment(name: "Test Attachment", source: "string attachment", type: Allure::ContentType::TXT)

    lifecycle.stop_test_step

    lifecycle.update_test_case do |tc|
      tc.status = Allure::Status::FAILED
      tc.status_details.message = "Fuuu, I failed"
      tc.status_details.trace = "I failed because I cought an exception to the knee"
    end

    lifecycle.add_attachment(name: "Test Attachment", source: image, type: Allure::ContentType::PNG)

    lifecycle.stop_test_case

    add_fixture(lifecycle, "After", "tear_down")

    lifecycle.stop_test_container
  end

  it "generate valid json", integration: true do
    allure_cli = Allure::Util.allure_cli
    expect(`#{allure_cli} generate -c #{Allure::Config.output_dir} -o reports/allure-report`.chomp).to(
      eq("Report successfully generated to reports/allure-report"),
    )
  end
end
