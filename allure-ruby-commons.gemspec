# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "allure_ruby_commons/version"

Gem::Specification.new do |s|
  s.name = "allure-ruby-commons"
  s.version = Allure::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.authors = ["Andrejs Cunskis"]
  s.email = ["andrejs.cunskis@gmail.com"]
  s.description = %(This is a helper library containing the basics for any ruby-based Allure adaptor.)
  s.summary = "allure_ruby_commons:#{Allure::Version::STRING}"
  s.homepage = "http://allure.qatools.ru"
  s.license = "Apache-2.0"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "uuid", "~> 2.3.9"
  s.add_dependency "require_all", "~> 2.0"
  s.add_dependency "json", ">= 1.8", "< 3"

  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rspec", "~> 3.8"
  s.add_development_dependency "rubocop", "~> 0.67"
  s.add_development_dependency "rubocop-performance", "~> 1.1"
  s.add_development_dependency "rubyzip", "~> 1.2"
  s.add_development_dependency "pry", "~> 0.12"
  s.add_development_dependency "solargraph", "~> 0.32"
end
