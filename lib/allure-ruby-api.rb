require 'allure-ruby-api/version'
require 'allure-ruby-api/builder'

module AllureRubyApi
  module Config
    class << self
      attr_accessor :output_dir

      DEFAULT_OUTPUT_DIR = 'allure/data'

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end
    end
  end

  class << self
    def configure(&block)
      yield Config
    end
  end

end