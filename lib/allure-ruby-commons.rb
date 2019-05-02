# rubocop:disable Naming/FileName
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

    # Get allure configuration
    # @return [Allure::Config]
    def configuration
      Config
    end

    # Set allure configuration
    # @yield [config]
    #
    # @yieldparam [Allure::Config]
    # @return [void]
    def configure
      yield(Config)
    end

    # Add attachment to current test or step
    # @param [String] name Attachment name
    # @param [File, String] source File or string to save as attachment
    # @param [String] type attachment type defined in {Allure::ContentType}
    # @param [Boolean] test_case add attachment to current test case
    # @return [void]
    def add_attachment(name:, source:, type:, test_case: false)
      lifecycle.add_attachment(name: name, source: source, type: type, test_case: test_case)
    end

    # Add link to test case
    # @param [String] name
    # @param [String] url
    # @return [void]
    def add_link(name, url)
      lifecycle.add_link(name, url)
    end
  end
end
# rubocop:enable Naming/FileName
