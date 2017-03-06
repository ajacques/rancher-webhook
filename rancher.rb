# frozen_string_literal: true
require 'restclient'
require_relative './rancher_service'

class Rancher
  def initialize
    @uris = { base: ENV['RANCHER_URI'] }
    @access_key = ENV['RANCHER_ACCESS_KEY'] || ENV['CATTLE_ACCESS_KEY']
    @secret_key = ENV['RANCHER_SECRET_KEY']  || ENV['CATTLE_SECRET_KEY']
    bootstrap_uris
  end

  def find_services_by_image_name(name, tag)
    s = services.select do |item|
      item['type'] == 'service' && item['launchConfig']['imageUuid'] == "docker:#{name}:#{tag}"
    end
    s.map do |item|
      RancherService.new self, item
    end
  end

  def find_service_by_uri(uri)
    RancherService.new(self, JSON.parse(RestClient::Request.execute(method: :get, url: uri, user: @access_key, password: @secret_key)))
  end

  def post_api(url, body)
    args = {
      method: :post,
      url: url,
      payload: body,
      user: @access_key,
      password: @secret_key,
      headers: { content_type: :json }
    }
    JSON.parse(RestClient::Request.execute(args))
  end

  private

  def services
    services = JSON.parse RestClient::Request.execute method: :get, url: @uris[:services], user: @access_key, password: @secret_key
    services['data']
  end

  def bootstrap_uris
    @uris[:services] = "#{@uris[:base]}/services"
  end
end
