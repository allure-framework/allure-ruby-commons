# frozen_string_literal: true

module Allure
  class AllureInterface
    def self.lifecycle
      Thread.current[:lifecycle] ||= AllureLifecycle.new
    end
  end
end
