class LighthouseAgent
  desc :check, "Run configured health checks"

  def check(system)
    load_system(system).services.each do |service|
      puts "Service: #{service.name} : #{healthy_to_s(service.healthy?)}"
      puts "    Host: #{healthy_to_s(service.host_healthy?)}"

      service.components.each do |component|
        puts "    #{component.name}: #{healthy_to_s(component.healthy?)}"
      end
    end
    puts
    check_baseline_connectivity!
  end

  no_commands do
    def healthy_to_s(result)
      status, message = result

      case status
      when true
        "Healthy".green 
      when nil
        "Unknown".yellow
      when false
        "Error - #{message}".red
      end
    end

    def check_baseline_connectivity!
      if Configuration.load.management_server
        baseline_host = URI.parse(Configuration.load.management_server).host
        r = Riemann::Client.new(host: baseline_host)
        r.tcp << { name: "Ping", tags: "ping" }
        status = "OK".green
      else
         status = "Not Configured".yellow
      end
    rescue
      status = "Unreachable".red
    ensure
      puts "Baseline Connectivity: #{status}"
    end
  end
end
