# frozen_string_literal: true

module Allure
  StatusDetail = Struct.new(:known, :muted, :flaky, :message, :trace) do
    def initialize(known: false, muted: false, flaky: false, message: nil, trace: nil)
      super(known, muted, flaky, message, trace)
    end
  end
end
