# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "allure_ruby_commons/version"

Gem::Specification.new do |s|
  s.name = "allure_ruby_commons"
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
  s.add_dependency "mimemagic", "~> 0.3.3"
  s.add_dependency "require_all", "~> 2.0"

  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rubocop", "~> 0.67"
  s.add_development_dependency "rubocop-performance", "~> 1.1"
  s.add_development_dependency "pry"
  s.add_development_dependency "solargraph"
end
