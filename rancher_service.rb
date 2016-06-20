class RancherService
  def initialize(client, opts={})
    @uri = opts['links']['self']
    @upgrade_uri = opts['actions']['upgrade']
    @current_service = opts['upgrade']['inServiceStrategy']
    @client = client
  end

  def upgrade
    payload = {
      toServiceStrategy: @current_service
    }
    response = @client.post_api @upgrade_uri, JSON.dump(payload)
  end
end
