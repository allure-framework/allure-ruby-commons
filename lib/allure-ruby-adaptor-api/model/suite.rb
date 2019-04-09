# frozen_string_literal: true

module AllureRubyAdaptorApi
  class Suite
    attr_accessor :stop
    attr_reader :title, :tests, :labels, :start
    def initialize(title, labels)
      @title = title
      @labels = Util.add_default_labels(labels)
      @tests = []
      @start = Util.timestamp
      @stop = nil
    end

    def add_test(test)
      @tests.push(test)
    end

    def to_xml(xml)
      args = { start: start || 0, stop: stop || 0, xmlns: "", "xmlns:ns2": "urn:model.allure.qatools.yandex.ru" }
      xml.send("ns2:test-suite", **args) do
        xml.send(:name, title)
        xml.send(:title, title)
        xml.send("test-cases") do
          tests.each { |test| test.to_xml(xml) }
        end
        Util.xml_labels(xml, labels)
      end
    end
  end
end
