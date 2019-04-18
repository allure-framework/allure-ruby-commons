# frozen_string_literal: true

require "logger"

module Allure
  class Config
    DEFAULT_OUTPUT_DIR = "gen/allure-results"
    DEFAULT_LOGGING_LEVEL = Logger::INFO

    class << self
      attr_writer :output_dir, :logging_level

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end

      def logging_level
        @logging_level || DEFAULT_LOGGING_LEVEL
      end
    end
  end
end
