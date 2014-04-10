require 'dante'

require_relative '../lib/monitor'
Thread.abort_on_exception=true

class BaselineAgent
  desc :start, "Continuously monitor the specified service"
  def start(system)
    return puts 'Must run as root'.red unless Process.uid == 0
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(daemonize: true) { Monitor.start!(system) }
  end

  desc :stop, "Stop monitoring the specified service"
  def stop(system)
    return puts 'Must run as root'.red unless Process.uid == 0
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(kill: true)
  end

  desc :restart, "Restart monitoring the specified service"
  def restart(system)
    return puts 'Must run as root'.red unless Process.uid == 0
    stop(system)
    start_monitor(system)
  end

  no_commands {
    def process_name(system)
      "baseline-#{StringHelpers.slugify(system.services.first.name)}"
    end
  }

end
