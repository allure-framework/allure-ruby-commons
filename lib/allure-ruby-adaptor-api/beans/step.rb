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
  end
end
