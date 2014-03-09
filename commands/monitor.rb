require 'dante'

require_relative '../lib/monitor'
Thread.abort_on_exception=true

class LighthouseAgent
  desc :start_monitor, "Continuously monitor the specified service"
  def start_monitor(system)
    return puts 'Must run as root'.red unless Process.uid == 0
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(daemonize: true) { monitor(system) }
  end

  desc :stop_monitor, "Stop monitoring the specified service"
  def stop_monitor(system)
    return puts 'Must run as root'.red unless Process.uid == 0
    system = load_system(system)
    Dante::Runner.new(process_name(system)).execute(kill: true)
  end

  no_commands {
    def process_name(system)
      "Lighthouse Agent - #{system.services.first.name}"
    end
  }

end
