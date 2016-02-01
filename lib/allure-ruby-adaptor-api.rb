require 'allure-ruby-adaptor-api/version'
require 'allure-ruby-adaptor-api/builder'
require 'logger'

module AllureRubyAdaptorApi
  module Config
    class << self
      attr_accessor :output_dir, :logging_level

      DEFAULT_OUTPUT_DIR = 'gen/allure-results'
      DEFAULT_LOGGING_LEVEL = Logger::INFO

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
