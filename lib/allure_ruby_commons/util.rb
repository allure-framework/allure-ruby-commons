# frozen_string_literal: true

require "socket"

module Allure
  class Util
    class << self
      HOSTNAME = Socket.gethostname

      def add_default_labels(labels = {})
        labels[:thread] ||= Thread.current.object_id
        labels[:host] ||= HOSTNAME
        labels
      end

      def timestamp(time = nil)
        ((time || Time.now).to_f * 1000).to_i
      end
    end
  end
end
