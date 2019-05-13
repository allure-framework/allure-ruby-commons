# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--color --require spec_helper --format documentation"
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = %w[--parallel]
end
