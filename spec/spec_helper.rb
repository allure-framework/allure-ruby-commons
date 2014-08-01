require 'rspec'
require 'allure-ruby-api'

AllureRubyApi.configure do |c|
  c.output_dir = "allure"
end