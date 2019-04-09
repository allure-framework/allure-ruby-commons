# frozen_string_literal: true

require "socket"

module AllureRubyAdaptorApi
  class Util
    class << self
      HOSTNAME = Socket.gethostname

      def add_default_labels(labels = {})
        labels[:thread] ||= Thread.current.object_id
        labels[:host] ||= HOSTNAME
        labels
      end

      def timestamp(time = nil)
        ((time || Time.now).to_f * 1000).to_i
      end

      def xml_attachments(xml, attachments)
        xml.attachments do
          attachments.each do |attach|
            xml.attachment(source: attach.source, title: attach.title, size: attach.size, type: attach.type)
          end
        end
      end

      def xml_labels(xml, labels)
        xml.labels do
          labels.each do |name, value|
            if value.is_a?(Array)
              value.each do |v|
                xml.label(name: name, value: v)
              end
            else
              xml.label(name: name, value: value)
            end
          end
        end
      end

      def validate_xml(xml)
        xsd = Nokogiri::XML::Schema(
          File.read(
            Pathname
              .new(File.dirname(__FILE__))
              .join("../../allure-model-#{AllureRubyAdaptorApi::Version::ALLURE}.xsd"),
          ),
        )
        doc = Nokogiri::XML(xml)

        xsd.validate(doc).each do |error|
          warn error.message
        end
        xml
      end
    end
  end
end
