require 'riemann/client'
require_relative 'check'

class Monitor
  def self.start!(system)
    baseline_host = URI.parse(Configuration.load.management_server).host
    r = Riemann::Client.new(host: baseline_host)

    checks = []
    system.services.each do |service|
      checks << Check.new(
        name: service.name,
        type: :service,
        service: service.name,
        interval: service.check_interval,
        client: r,
        check: service.health,
      ) if service.health

      checks << Check.new(
        name: 'Host',
        type: :host,
        interval: service.host_check_interval,
        client: r,
        check: service.host_health,
      ) if service.host_health

      service.components.each do |component|
        checks << Check.new(
          name: component.name,
          type: :component,
          service: service.name,
          component: component.name,
          interval: component.check_interval,
          client: r,
          check: component.health
        ) if component.health
      end
    end

    threads = checks.map(&:start!)
    puts "Started #{threads.size} monitoring threads"
    threads.map(&:join)
    trap("SIGINT") { threads.map(&:stop!) }
  end
end
