# frozen_string_literal: true

require "require_all"
require "uuid"
require_rel "allure_ruby_commons/**/*rb"

module Allure
  class << self
    # Get thread specific allure lifecycle object
    # @return [Allure::AllureLifecycle]
    def lifecycle
      Thread.current[:lifecycle] ||= AllureLifecycle.new
    end

    # Set allure configuration
    # @yield [config]
    #
    # @yieldparam [Allure::Config]
    # @return [void]
    def configure
      yield(Config)
    end
  end
end
