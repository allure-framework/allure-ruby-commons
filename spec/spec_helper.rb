# frozen_string_literal: true

require "pry"
require "rspec"
require "allure_ruby_commons"

Allure.configure { |config| config.output_dir = "allure" }
