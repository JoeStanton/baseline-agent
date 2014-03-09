require 'socket'
require 'rest_client'

class LighthouseAgent
  desc :setup, "Register this host with the management server"

  def setup(url)
    options = {
      host: {
        hostname: Socket.gethostname,
        environment: :development
      }
    }

    RestClient.post "#{url}/hosts/", options.to_json, content_type: :json
    Configuration.new(management_server: url).save
  end
end
