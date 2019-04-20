# frozen_string_literal: true

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }
  let(:file_writer) { double("FileWriter") }
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
  end

  it "adds attachment to step" do
    expect(file_writer).to receive(:write_attachment).with("string attachment", duck_type(:name, :source, :type))

    test_step = start_test_step(lifecycle, name: "Step name", descrption: "step description")
    lifecycle.attachment(**attach_opts)
    attachment = test_step.attachments.last

    aggregate_failures "Attachment should be added" do
      expect(attachment.name).to eq("Test Attachment")
      expect(attachment.type).to eq(Allure::ContentType::TXT)
    end
  end

  it "adds attachment to test" do
    expect(file_writer).to receive(:write_attachment).with("string attachment", duck_type(:name, :source, :type))

    lifecycle.attachment(**attach_opts)
    attachment = @test_case.attachments.last

    aggregate_failures "Attachment should be added" do
      expect(attachment.name).to eq("Test Attachment")
      expect(attachment.type).to eq(Allure::ContentType::TXT)
    end
  end

  it "raises no running test case exception" do
    allow(file_writer).to receive(:write_test_result)

    lifecycle.stop_test_case
    expect { lifecycle.attachment(**attach_opts) }.to raise_error(/no test or step is running/)
  end

  it "raises incorrect mime type exception" do
    expect do
      lifecycle.attachment(
        name: "Test Attachment",
        source: "string attachment",
        type: "nonsence",
      )
    end.to raise_error(/unrecognized mime type: nonsence/)
  end
end
