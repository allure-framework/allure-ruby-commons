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
  end
end
