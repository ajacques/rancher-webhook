require 'active_job'
require 'resque'

ActiveJob::Base.queue_adapter = :resque
Resque.redis = ENV['REDIS_URI']
