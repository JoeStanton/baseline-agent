require 'rest_client'

class BaselineAgent
  desc :pull, "Pull the specified service spec from the management server"
  def pull(system)
    config = Configuration.load
    response = RestClient.get "#{config.management_server}/services/#{system}/spec"
    File.write("#{system}.rb", response.body)
  end
end
