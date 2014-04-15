class Host
  def self.register(system)
    url = Configuration.load.management_server
    RestClient.put "#{url}/hosts/#{Socket.gethostname}", { host: { service_slug: StringHelpers.slugify(system.services.first.name) } }.to_json, content_type: :json
  end

  def self.deregister(system)
    url = Configuration.load.management_server
    RestClient.put "#{url}/hosts/#{Socket.gethostname}", { host: { service_slug: "nil" } }.to_json, content_type: :json
  end
end
