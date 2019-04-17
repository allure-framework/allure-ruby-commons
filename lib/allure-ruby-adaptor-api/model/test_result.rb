# frozen_string_literal: true

module Allure
  class TestResult < ExecutableItem
    def initialize(**options)
      super
      @uuid = options[:uuid] || UUID.generate
      @history_id = options[:history_id] || UUID.generate
      @full_name = full_name
      @labels = []
      @links = []
    end

    attr_accessor :uuid, :history_id, :full_name, :labels, :links
  end
end
