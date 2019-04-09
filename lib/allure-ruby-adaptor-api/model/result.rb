# frozen_string_literal: true

module AllureRubyAdaptorApi
  class Result
    attr_accessor :status, :started_at, :finished_at
    attr_reader :stacktrace, :message
    def initialize(status, exception = nil)
      @status = status
      @stacktrace = (exception&.backtrace || []).map(&:to_s).join("\r\n")
      @message = exception.to_s
    end

    def ok?
      @status == TestStatus::PASSED
    end
  end
end
