require 'rspec'
require 'allure-ruby-adaptor-api'

AllureRubyAdaptorApi.configure do |c|
  c.output_dir = "allure"
end
