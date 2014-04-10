require 'socket'
require 'rest_client'

class BaselineAgent
  desc :setup, "Register this host with the management server"
  method_option :service, required: false
  method_option :environment, default: "development"

  def setup(url)
    params = {
      service_slug: options.service,
      environment: options.environment
    }

    RestClient.put "#{url}/hosts/#{Socket.gethostname}", { host: params }.to_json, content_type: :json
    Configuration.new(management_server: url).save
  end
end
