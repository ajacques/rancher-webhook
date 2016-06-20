require 'active_job'
require_relative './rancher'

class FinalizeUpgradeJob < ActiveJob::Base
  def perform(opts)
    client = Rancher.new uri: ENV['RANCHER_URI'], access_key: ENV['RANCHER_ACCESS_KEY'], secret_key: ENV['RANCHER_SECRET_KEY']
    service = client.find_service_by_uri(opts[:service_uri])
    return unless service
    if service.upgraded?
      service.finalize_upgrade
    else
      FinalizeUpgradeJob.set(wait: 20.seconds).perform_later(service_uri: service.uri)
    end
  end
end
