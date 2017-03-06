# frozen_string_literal: true
require 'active_job'
require_relative './rancher'

class FinalizeUpgradeJob < ActiveJob::Base
  def perform(opts)
    client = Rancher.new
    service = client.find_service_by_uri(opts[:service_uri])
    return unless service
    if service.upgraded?
      service.finalize_upgrade
    else
      FinalizeUpgradeJob.set(wait: 20.seconds).perform_later(service_uri: service.uri)
    end
  end
end
