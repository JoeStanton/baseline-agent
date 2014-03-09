require 'riemann/client'
require_relative 'check'

class Monitor
  def self.start!(system)
    r = Riemann::Client.new

    checks = []
    system.services.each do |service|
      checks << Check.new(service.name, service.check_interval, r, service.health)
      checks << Check.new("Host", service.host_check_interval, r, service.host_health)

      service.components.each do |component|
        checks << Check.new(component.name, service.check_interval, r, component.health)
      end
    end

    threads = checks.map(&:start!)
    puts "Started #{threads.size} monitoring threads"
    threads.map(&:join)
    trap("SIGINT") { threads.map(&:stop!) }
  end
end
