# frozen_string_literal: true

require 'active_job'
require_relative './rancher'
require_relative './finalize_upgrade_job'

require 'rest-client'
RestClient.log = 'stdout'

class UpgradeJob < ActiveJob::Base
  def perform(opts)
    client = Rancher.new
    services = client.find_services_by_image_name(opts[:repo_name], opts[:tag])
    services.each do |service|
      service.upgrade
      FinalizeUpgradeJob.set(wait: 20.seconds).perform_later(service_uri: service.uri)
    end
  end
end
