# frozen_string_literal: true

require 'active_job'
require_relative './rancher'
require_relative './finalize_upgrade_job'

require 'rest-client'
RestClient.log = 'stdout'

class UpgradeJob < ActiveJob::Base
  def perform(opts)
    client = Rancher.new uri: ENV['RANCHER_URI'], access_key: ENV['RANCHER_ACCESS_KEY'], secret_key: ENV['RANCHER_SECRET_KEY']
    service = client.find_service_by_image_name(opts[:repo_name], opts[:tag])
    return unless service
    service.upgrade
    FinalizeUpgradeJob.set(wait: 20.seconds).perform_later(service_uri: service.uri)
  end
end
