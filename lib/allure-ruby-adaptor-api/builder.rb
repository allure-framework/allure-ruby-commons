# frozen_string_literal: true

require "digest"
require "logger"
require "mimemagic"
require "nokogiri"
require "uuid"
require "pathname"

module AllureRubyAdaptorApi
  class Builder
    class << self
      # @return [AllureRubyAdaptorApi::Suite]
      def current_suite
        thread[:suites].last
      end

      # @return [AllureRubyAdaptorApi::Test]
      def current_test
        current_suite.tests.last
      end

      # @return [AllureRubyAdaptorApi::Step]
      def current_step
        current_test.steps.last
      end

      # Start test suite
      # @param [String] title
      # @return [void]
      def start_suite(title, labels = {})
        init_suites
        logger.debug "Starting suite '#{title}'"
        thread[:suites].push(Suite.new(title, labels))
      end

      # Start test case
      # @param [String] title
      # @param [Hash] labels
      # @return [void]
      def start_test(title, labels = {})
        logger.debug "Starting test '#{current_suite.title}':'#{title}'"
        current_suite.add_test(Test.new(title, labels))
      end

      # Stop test case
      # @param [AllureRubyAdaptorApi::Result] result
      # @return [void]
      def stop_test(result)
        logger.debug "Stopping test '#{current_suite.title}':'#{current_test.title}'"
        current_test.start = Util.timestamp(result.started_at) if result.started_at
        current_test.stop = Util.timestamp(result.finished_at)
        current_test.result = result
      end

      # Start test step
      # @param [AllureRubyAdaptorApi::Suite] suite
      # @param [AllureRubyAdaptorApi::Test] test
      # @param [AllureRubyAdaptorApi::Step] step
      # @return [void]
      def start_step(title)
        logger.debug "Starting step '#{current_suite.title}':'#{current_test.title}':'#{title}'"
        current_test.add_step(Step.new(title))
      end

      # @param [String] file
      # @param [String] mime_type
      # @param [String] title
      # @return [void]
      def add_attachment(file:, mime_type: nil, title: nil)
        mime_type ||= MimeMagic.by_path(file.path) || "text/plain"
        title ||= File.basename(file)
        attachment_path = create_attach_file(file, title)
        attachment = Attachment.new(mime_type, title, attachment_path)

        current_step ? current_step.add_attachment(attachment) : current_test.add_attachment(attachment)
      end

      # Stop test step
      # @param [Symbol] status
      # @return [void]
      def stop_step(status = :passed)
        logger.debug "Stopping step '#{current_suite.title}':'#{current_test.title}':'#{current_step.title}'"
        current_step.stop = Util.timestamp
        current_step.status = status
      end

      # Stop test suite
      # @return [void]
      def stop_suite
        logger.debug "Stopping case_or_suite '#{current_suite.title}'"
        current_suite.stop = Util.timestamp
        write_suite(current_suite) unless current_suite.tests.empty?
      end

      private

      def thread
        Thread.current
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def config
        AllureRubyAdaptorApi::Config
      end

      def output_dir
        @output_dir ||= FileUtils.mkpath(config.output_dir).first
      end

      def init_suites
        thread[:suites] ||= []
        logger.level = config.logging_level
      end

      def create_attach_file(file, title)
        logger.debug(
          "Adding attachment '#{title}' to '#{current_suite.title}':'#{current_test.title}':'#{current_step&.title}'",
        )
        file_extname = File.extname(file.path.downcase)
        path = Pathname.new(output_dir).join(
          "#{Digest::SHA256.file(file.path).hexdigest}-attachment#{file_extname.empty? ? '' : file_extname}",
        )

        logger.debug "Copying attachment to '#{path}'..."
        FileUtils.cp(file.path, path)
        path
      end

      def write_suite(suite)
        xml_report = Nokogiri::XML::Builder.new { |xml| suite.to_xml(xml) }.to_xml
        out_file = Pathname.new(output_dir).join("#{UUID.new.generate}-testsuite.xml")
        logger.debug "Writing file '#{out_file}'..."
        File.open(out_file, "w+") { |file| file.write(Util.validate_xml(xml_report)) }
        xml_report
      end
    end
  end
end
