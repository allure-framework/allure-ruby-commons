# frozen_string_literal: true

module AllureRubyAdaptorApi
  class Test
    attr_accessor :result, :start, :stop, :labels
    attr_reader :title, :steps, :attachments

    def initialize(title, labels = { severity: :normal })
      @title = title
      @labels = Util.add_default_labels(labels)
      @steps = []
      @attachments = []
      @result = nil
      @start = Util.timestamp
      @stop = nil
    end

    def add_step(step)
      @steps.push(step)
    end

    def add_attachment(attachment)
      @attachments.push(attachment)
    end

    def add_labels(labels)
      @labels.merge!(labels)
    end

    def to_xml(xml)
      xml.send("test-case", start: start || 0, stop: stop || 0, status: result.status.to_s) do
        xml.send(:name, title)
        xml.send(:title, title)
        failure_node(xml) unless result.ok?
        xml.steps do
          steps.each { |step| step.to_xml(xml) }
        end
        Util.xml_attachments(xml, attachments) unless attachments.empty?
        Util.xml_labels(xml, labels.merge(labels))
        xml.parameters
      end
    end

    private

    def failure_node(xml)
      xml.failure do
        xml.message(result.message)
        xml.send("stack-trace", result.stacktrace)
      end
    end
  end
end
