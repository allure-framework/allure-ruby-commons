# frozen_string_literal: true

require "require_all"
require_rel "allure_ruby_commons/**/*rb"

module Allure
  class << self
    def lifecycle
      Thread.current[:lifecycle] ||= AllureLifecycle.new
    end

    def configure
      yield(Config)
    end
  end
end
