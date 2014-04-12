require 'dante'

require_relative '../lib/monitor'
Thread.abort_on_exception=true

class BaselineAgent
  desc :start, "Continuously monitor the specified service"
  def start(system)
    require_root!
    require_setup!
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(daemonize: true) { Monitor.start!(system) }
  end

  desc :stop, "Stop monitoring the specified service"
  def stop(system)
    require_root!
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(kill: true)
  end

  desc :restart, "Restart monitoring the specified service"
  def restart(system)
    require_root!
    require_setup!
    stop(system)
    start(system)
  end

  no_commands {
    def process_name(system)
      "baseline-#{StringHelpers.slugify(system.services.first.name)}"
    end
  }

end
