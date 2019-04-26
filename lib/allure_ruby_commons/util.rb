# frozen_string_literal: true

require "socket"

module Allure
  class Util
    class << self
      def default_labels
        [Label.new("thread", Thread.current.object_id), Label.new("host", Socket.gethostname)]
      end

      def timestamp(time = nil)
        ((time || Time.now).to_f * 1000).to_i
      end
    end
  end
end
