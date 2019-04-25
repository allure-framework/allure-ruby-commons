# frozen_string_literal: true

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }
  let(:logger) { double("Logger") }
  let(:attach_opts) do
    {
      name: "Test Attachment",
      source: "string attachment",
      type: Allure::ContentType::TXT,
    }
  end

  before do
    @result_container = start_test_container(lifecycle, "Container name")
    @test_case = start_test_case(lifecycle, name: "Test case", full_name: "Full name")

    allow(Allure::FileWriter).to receive(:new).and_return(file_writer)
    allow(Logger).to receive(:new).and_return(logger)
  end

  it "adds attachment to step" do
    expect(file_writer).to receive(:write_attachment).with("string attachment", duck_type(:name, :source, :type))

    test_step = start_test_step(lifecycle, name: "Step name", descrption: "step description")
    lifecycle.add_attachment(**attach_opts)
    attachment = test_step.attachments.last

    aggregate_failures "Attachment should be added" do
      expect(attachment.name).to eq("Test Attachment")
      expect(attachment.type).to eq(Allure::ContentType::TXT)
    end
  end

  it "adds attachment to test" do
    expect(file_writer).to receive(:write_attachment).with("string attachment", duck_type(:name, :source, :type))

    lifecycle.add_attachment(**attach_opts)
    attachment = @test_case.attachments.last

    aggregate_failures "Attachment should be added" do
      expect(attachment.name).to eq("Test Attachment")
      expect(attachment.type).to eq(Allure::ContentType::TXT)
    end
  end

  it "logs no running test case error" do
    allow(file_writer).to receive(:write_test_result)

    expect(logger).to receive(:error).with(/no test or step is running/)

    lifecycle.stop_test_case
    lifecycle.add_attachment(**attach_opts)
  end

  it "logs incorrect mime type error" do
    expect(logger).to receive(:error).with(/unrecognized mime type: nonsence/)

    lifecycle.add_attachment(
      name: "Test Attachment",
      source: "string attachment",
      type: "nonsence",
    )
  end
end
