# frozen_string_literal: true
require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup do
    require_relative './init_env'
    require_relative './upgrade_job'
  end
end

task default: [:rubocop]
