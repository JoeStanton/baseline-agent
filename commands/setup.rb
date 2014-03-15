require 'socket'
require 'rest_client'

class LighthouseAgent
  desc :setup, "Register this host with the management server"
  method_option :service, required: true
  method_option :environment, default: "development"

  def setup(url)
    params = {
      host: {
        hostname: Socket.gethostname,
        service_slug: options.service,
        environment: options.environment
      }
    }

    RestClient.post "#{url}/hosts/", params.to_json, content_type: :json
    Configuration.new(management_server: url).save
  end
end
