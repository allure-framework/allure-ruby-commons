# frozen_string_literal: true

module Allure
  class StatusDetail < JSONable
    def initialize(known: false, muted: false, flaky: false, message: nil, trace: nil)
      @known = known
      @muted = muted
      @flaky = flaky
      @message = message
      @trace = trace
    end
  end
end
