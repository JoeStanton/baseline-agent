class LighthouseAgent
  desc :check, "Run configured health checks"

  def check(system)
    load_system(system).services.each do |service|
      puts "checking service #{service.name} : #{healthy_to_s(service.healthy?)}"
      puts "    checking Host : #{healthy_to_s(service.host_healthy?)}"

      service.components.each do |component|
        puts "    checking #{component.name} : #{healthy_to_s(component.healthy?)}"
      end
    end
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
  end
end
