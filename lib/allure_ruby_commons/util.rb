# frozen_string_literal: true

module Allure
  class Util
    class << self
      def timestamp(time = nil)
        ((time || Time.now).to_f * 1000).to_i
      end
    end
  end
end
