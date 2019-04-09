# frozen_string_literal: true

module AllureRubyAdaptorApi
  class Step
    attr_accessor :stop, :status, :attachments
    attr_reader :title, :start
    def initialize(title)
      @title = title
      @start = Util.timestamp
      @attachments = []
      @stop = nil
      @status = nil
    end

    def add_attachment(attachment)
      @attachments.push(attachment)
    end

    def to_xml(xml)
      xml.step(start: start || 0, stop: stop || 0, status: status.to_s) do
        xml.send(:name, title)
        xml.send(:title, title)
        Util.xml_attachments(xml, attachments) unless attachments.empty?
      end
    end
  end
end
