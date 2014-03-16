require 'rest_client'

class LighthouseAgent
  desc :push, "Pushes the specified service to a management server"

  def push(system)
    load_system(system).services.each do |service|
      config = Configuration.load
      data = { service: service.to_hash }
      RestClient.put "#{config.management_server}/services/#{StringHelpers.slugify(service.name)}", data.to_json, content_type: :json
    end
  end
end
