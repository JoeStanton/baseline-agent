require 'socket'
require 'rest_client'

class LighthouseAgent
  desc :setup, "Register this host with the management server"
  method_option :service, required: false
  method_option :environment, default: "development"

  def setup(url)
    params = {
        hostname: Socket.gethostname,
        service_slug: options.service,
        environment: options.environment
    }

    RestClient.post "#{url}/hosts/", { host: params }.to_json, content_type: :json
    Configuration.new(management_server: url).save
  end
end
