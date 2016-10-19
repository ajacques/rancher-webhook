# frozen_string_literal: true

# Represents a single Rancher server that is upgradable
class RancherService
  def initialize(client, opts = {})
    @client = client
    @data = opts
  end

  def upgraded?
    @data['state'] == 'upgraded'
  end

  def upgrade
    strategy = current_service
    strategy['startFirst'] = start_first?

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

  def start_first?
    launch_config = current_service['launchConfig']
    if launch_config.key? 'environment'
      launch_config['environment']['RANCHER_NON_OVERLAPPED_UPGRADES']
    else
      false
    end
  end
end
