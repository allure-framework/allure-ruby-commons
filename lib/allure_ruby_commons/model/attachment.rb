# frozen_string_literal: true

module Allure
  Attachment = Struct.new(:name, :type, :source, keyword_init: true)
end
