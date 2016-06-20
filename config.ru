require 'rubygems'
require 'bundler'

Bundler.require
require 'resque/server'

use Resque::Server
require './server'
run Sinatra::Application
