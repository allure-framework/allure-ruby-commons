# frozen_string_literal: true

require "pry"
require "rspec"
require "allure_ruby_commons"

Allure.configure do |c|
  c.output_dir = "allure"
end
