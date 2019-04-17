# frozen_string_literal: true

module Allure
  class ExecutableItem
    def initialize(**options)
      @name = options[:name]
      @description = options[:description]
      @description_html = options[:description_html]
      @status = options[:status] || Status::BROKEN
      @status_detail = options[:status_detail] || StatusDetail.new
      @stage = options[:stage] || Stage::SCHEDULED
      @steps = options[:steps] || []
      @attachments = options[:attachments] || []
      @parameters = options[:parameters] || []
    end

    attr_accessor(
      :name, :status, :status_detail, :stage, :description, :description_html,
      :steps, :attachments, :parameters, :start, :stop
    )
  end
end
