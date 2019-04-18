# frozen_string_literal: true

module Allure
  class TestResult < ExecutableItem
    def initialize(**options)
      super
      @uuid = options[:uuid] || UUID.new.generate
      @history_id = options[:history_id] || UUID.new.generate
      @full_name = full_name
      @labels = []
      @links = []
    end

    attr_accessor :uuid, :history_id, :full_name, :labels, :links
  end
end
