# frozen_string_literal: true

require "pry"
require "rspec"
require "allure-ruby-adaptor-api"

Allure.configure do |c|
  c.output_dir = "allure"
end
