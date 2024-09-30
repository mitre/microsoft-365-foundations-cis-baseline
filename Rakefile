# frozen_string_literal: true

# !/usr/bin/env rake

require 'rake/testtask'
require 'rubocop/rake_task'

namespace :inspec do
  desc 'validate the inspec profile'
  task :check do
    system 'bundle exec inspec check .'
  end
end

begin
  RuboCop::RakeTask.new(:lint) do |task|
    task.options += %w[--display-cop-names --no-color --parallel]
  end
rescue LoadError
  puts 'rubocop is not available. Install the rubocop gem to run the lint tests.'
end

desc 'pre-commit checks'
task pre_commit_checks: [:lint, 'inspec:check']
