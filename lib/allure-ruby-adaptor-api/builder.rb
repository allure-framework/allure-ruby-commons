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
      THREAD = Thread.current
      MUTEX = Mutex.new
      LOGGER = Logger.new(STDOUT)

      # Start test suite
      # @param [String] title
      # @return [void]
      def start_suite(title, labels = {})
        init_suites
        LOGGER.debug "Starting suite #{title}"
        THREAD[:suites].push(Suite.new(title, labels))
      end

      # Start test case
      # @param [String] title
      # @param [Hash] labels
      # @return [void]
      def start_test(title, labels = {})
        LOGGER.debug "Starting test #{current_suite.title}.#{title}"
        current_suite.add_test(Test.new(title, labels))
      end

      # Stop test case
      # @param [AllureRubyAdaptorApi::Result] result
      # @return [void]
      def stop_test(result)
        LOGGER.debug "Stopping test #{current_suite.title}.#{current_test.title}"
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
        LOGGER.debug "Starting step #{current_suite.title}.#{current_test.title}.#{title}"
        current_test.add_step(Step.new(title))
      end

      # @param [String] file
      # @param [String] mime_type
      # @param [String] title
      # @return [void]
      def add_attachment(file:, mime_type: nil, title: nil)
        title ||= File.basename(file)
        LOGGER.debug  "Adding attachment #{title} to #{current_suite.title}.#{current_test.title}#{current_step.title}"
        dir = Pathname.new(Dir.pwd).join(config.output_dir)
        FileUtils.mkdir_p(dir)
        file_extname = File.extname(file.path.downcase)
        mime_type ||= MimeMagic.by_path(file.path) || "text/plain"
        attachment = dir.join("#{Digest::SHA256.file(file.path).hexdigest}-attachment#{(file_extname.empty?) ? '' : file_extname}")
        LOGGER.debug "Copying attachment to '#{attachment}'..."
        FileUtils.cp(file.path, attachment)
        attach = {
            type: mime_type,
            title: title,
            source: attachment.basename,
            file: attachment.basename,
            target: attachment.basename,
            size: File.stat(attachment).size
        }
        if current_step.nil?
          current_test.add_attachment(attach)
        else
          current_step.add_attachment(attach)
        end
      end

      # Stop test step
      # @param [Symbol] status
      # @return [void]
      def stop_step(status = :passed)
        MUTEX.synchronize do
          LOGGER.debug "Stopping step #{current_suite.title}.#{current_test.title}.#{current_step.title}"
          current_step.stop = Util.timestamp
          current_step.status = status
        end
      end

      # Stop test suite
      # @return [void]
      def stop_suite
        LOGGER.debug "Stopping case_or_suite #{current_suite.title}"
        current_suite.stop = Util.timestamp
      end

      def build!(opts = {}, &block)
        suites_xml = []
        (THREAD[:suites] || []).each do |suite|
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.send "ns2:test-suite", :start => suite.start || 0, :stop => suite.stop || 0, "xmlns" => "", "xmlns:ns2" => "urn:model.allure.qatools.yandex.ru" do
              xml.send :name, suite.title
              xml.send :title, suite.title
              xml.send "test-cases" do
                suite.tests.each do |test|
                  xml.send "test-case", start: test.start || 0, stop: test.stop || 0, status: test.result.status.to_s do
                    xml.send :name, test.title
                    xml.send :title, test.title
                    unless test.result.ok?
                      xml.failure do
                        xml.message test.result.message
                        xml.send "stack-trace", test.result.stacktrace
                      end
                    end
                    xml.steps do
                      test.steps.each do |step|
                        xml.step(start: step.start || 0, stop: step.stop || 0, status: step.status.to_s) do
                          xml.send :name, step.title
                          xml.send :title, step.title
                          xml_attachments(xml, step.attachments)
                        end
                      end
                    end
                    xml_attachments(xml, test.attachments)
                    xml_labels(xml, suite.labels.merge(test.labels))
                    xml.parameters
                  end
                end
              end
              xml_labels(xml, suite.labels)
            end
          end
          unless suite.tests.empty?
            xml = builder.to_xml
            xml = yield suite, xml if block_given?
            dir = Pathname.new(config.output_dir)
            FileUtils.mkdir_p(dir)
            out_file = dir.join("#{UUID.new.generate}-testsuite.xml")
            LOGGER.debug "Writing file '#{out_file}'..."
            File.open(out_file, "w+") do |file|
              file.write(validate_xml(xml))
            end
            suites_xml << xml
          end
        end
        suites_xml
      end

      private

      # @return [AllureRubyAdaptorApi::Suite]
      def current_suite
        THREAD[:suites].last
      end

      # @return [AllureRubyAdaptorApi::Test]
      def current_test
        current_suite.tests.last
      end

      # @return [AllureRubyAdaptorApi::Step] <description>
      def current_step
        current_test.steps.last
      end

      def config
        AllureRubyAdaptorApi::Config
      end

      def init_suites
        THREAD[:suites] ||= []
        LOGGER.level = config.logging_level
      end

      def validate_xml(xml)
        xsd = Nokogiri::XML::Schema(File.read(Pathname.new(File.dirname(__FILE__)).join("../../allure-model-#{AllureRubyAdaptorApi::Version::ALLURE}.xsd")))
        doc = Nokogiri::XML(xml)

        xsd.validate(doc).each do |error|
          $stderr.puts error.message
        end
        xml
      end

      def xml_attachments(xml, attachments)
        xml.attachments do
          attachments.each do |attach|
            xml.attachment source: attach[:source], title: attach[:title], size: attach[:size], type: attach[:type]
          end
        end
      end

      def xml_labels(xml, labels)
        xml.labels do
          labels.each do |name, value|
            if value.is_a?(Array)
              value.each do |v|
                xml.label name: name, value: v
              end
            else
              xml.label name: name, value: value
            end
          end
        end
      end
    end
  end
end
