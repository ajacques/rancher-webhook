# frozen_string_literal: true
require 'restclient'
require_relative './rancher_service'

class Rancher
  def initialize(uri:, access_key:, secret_key:)
    @uris = { base: uri }
    @access_key = access_key
    @secret_key = secret_key
    bootstrap_uris
  end

  def find_service_by_image_name(name, tag)
    services.each do |item|
      if item['type'] == 'service' && item['launchConfig']['imageUuid'] == "docker:#{name}:#{tag}"
        return RancherService.new self, item
      end
    end
    nil
  end

  def find_service_by_uri(uri)
    RancherService.new(self, JSON.parse(RestClient::Request.execute(method: :get, url: uri, user: @access_key, password: @secret_key)))
  end

  def post_api(url, body)
    JSON.parse(RestClient::Request.execute(method: :post, url: url, payload: body, user: @access_key, password: @secret_key, headers: { content_type: :json }))
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
