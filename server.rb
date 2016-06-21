# frozen_string_literal: true

require 'sinatra'
require 'rack/contrib'
require_relative './init_env'
require_relative './rancher'
require_relative './upgrade_job'

use Rack::PostBodyContentTypeParser

post '/docker_hub' do
  body = request.env['rack.request.form_hash']
  UpgradeJob.perform_later(repo_name: body['repository']['repo_name'], tag: body['push_data']['tag'])
  status 202
end
