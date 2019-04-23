# frozen_string_literal: true

module Allure
  class TestResult < ExecutableItem
    def initialize(uuid: UUID.generate, history_id: UUID.generate, **options)
      super
      @uuid = uuid
      @history_id = history_id
      @full_name = options[:full_name] || "Unnamed"
      @labels = options[:labels] || []
      @links = options[:links] || []
    end

    attr_accessor :uuid, :history_id, :full_name, :labels, :links
  end
end
