require 'sinatra'
require 'json'
require 'net/http'
require 'rack/contrib'
require_relative './rancher'

use Rack::PostBodyContentTypeParser

Resque.redis = ENV['REDIS_URI']

client = Rancher.new uri: ENV['RANCHER_URI'], access_key: ENV['RANCHER_ACCESS_KEY'], secret_key: ENV['RANCHER_SECRET_KEY']

post '/docker_hub' do
  body = request.env['rack.request.form_hash']
  UpgradeJob.perform_later(repo_name: body['repository']['repo_name'], tag: body['push_data']['tag'])
  status 202
end
