# frozen_string_literal: true

require_relative "jsonable"

module Allure
  class Attachment < JSONable
    def initialize(name:, type:, source:)
      @name = name
      @type = type
      @source = source
    end

    attr_accessor :name, :type, :source
  end
end
