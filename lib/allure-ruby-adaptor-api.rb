# frozen_string_literal: true

require "require_all"
require "logger"

require_rel "allure-ruby-adaptor-api/**/*rb"

module AllureRubyAdaptorApi
  module Config
    class << self
      DEFAULT_OUTPUT_DIR = "gen/allure-results"
      DEFAULT_LOGGING_LEVEL = Logger::INFO

      attr_writer :output_dir, :logging_level

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end

      def logging_level
        @logging_level || DEFAULT_LOGGING_LEVEL
      end
    end
  end

  class << self
    def configure(&block)
      yield Config
    end
  end

end
