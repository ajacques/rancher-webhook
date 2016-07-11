# frozen_string_literal: true

class RancherService
  def initialize(client, opts = {})
    @client, @data = client, opts
  end

  def upgraded?
    @data['state'] == 'upgraded'
  end

  def upgrade
    strategy = current_service
    strategy['startFirst'] = !strategy['launchConfig']['environment'].key? 'RANCHER_NON_OVERLAPPED_UPGRADES'
    payload = {
      inServiceStrategy: strategy
    }
    @client.post_api upgrade_uri, JSON.dump(payload)
  end

  def finalize_upgrade
    @client.post_api finish_upgrade_uri, '{}'
  end

  def uri
    @data['links']['self']
  end

  private

  def current_service
    @data['upgrade']['inServiceStrategy']
  end

  def upgrade_uri
    @data['actions']['upgrade']
  end

  def finish_upgrade_uri
    @data['actions']['finishupgrade']
  end
end
