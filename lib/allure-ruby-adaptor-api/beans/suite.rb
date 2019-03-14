# frozen_string_literal: true

module AllureRubyAdaptorApi
  class Suite
    attr_accessor :stop
    attr_reader :title, :tests, :labels, :start
    def initialize(title, labels)
      @title = title
      @labels = Util.add_default_labels(labels)
      @tests = []
      @start = Util.timestamp
      @stop = nil
    end

    def add_test(test)
      @tests.push(test)
    end
  end
end
