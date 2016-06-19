require 'sinatra'
require 'json'
require 'net/http'

post '/docker_hub', provides: [:json] do
	input = JSON.parse(request.read)
end