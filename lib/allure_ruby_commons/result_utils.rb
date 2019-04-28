# frozen_string_literal: true

require "socket"

module Allure
  module ResultUtils
    class << self
      def thread_label
        Label.new("thread", Thread.current.object_id)
      end

      def host_label
        Label.new("host", Socket.gethostname)
      end
    end
  end
end
