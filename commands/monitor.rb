require 'dante'

require_relative '../lib/monitor'
Thread.abort_on_exception=true

class BaselineAgent
  desc :start, "Continuously monitor the specified service"
  def start(system)
    require_root!
    require_setup!
    system = load_system(system)
    register_host(system)
    Dante::Runner.new(process_name(system)).execute(daemonize: true) { Monitor.start!(system) }
  end

  desc :stop, "Stop monitoring the specified service"
  def stop(system)
    require_root!
    system = load_system(system)
    deregister_host(system)
    Dante::Runner.new(process_name(system)).execute(kill: true)
  end

  desc :restart, "Restart monitoring the specified service"
  def restart(system)
    require_root!
    require_setup!
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(kill: true)
    Dante::Runner.new(process_name(system)).execute(daemonize: true) { Monitor.start!(system) }
  end

  no_commands {
    def process_name(system)
      "baseline-#{StringHelpers.slugify(system.services.first.name)}"
    end

    def register_host(system)
      url = Configuration.load.management_server
      RestClient.put "#{url}/hosts/#{Socket.gethostname}", { host: { service_slug: StringHelpers.slugify(system.services.first.name) } }.to_json, content_type: :json
    end

    def deregister_host(system)
      url = Configuration.load.management_server
      RestClient.put "#{url}/hosts/#{Socket.gethostname}", { host: { service_slug: "nil" } }.to_json, content_type: :json
    end
  }

end
