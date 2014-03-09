require './dsl'
require 'colorize'
require 'socket'

require 'riemann/client'
r = Riemann::Client.new

system = DSL.load ARGV[0]

class Check
  attr_reader :thread

  def initialize(name, interval, client, check)
    @name = name
    @interval = interval
    @client = client
    @check = check
    @hostname = Socket.gethostname
  end

  def report(status)
    puts "#{@name} - #{status}"
    @client << {
      host: @hostname,
      service: @name,
      state: status ? 'ok' : 'error',
      metric: @latency,
      description: "#{@name} Check",
      tags: ['check'],
      ttl: @interval*2
    }
  end

  def start!
    @thread = Thread.new do
      while true
        report(@check.call)
        sleep @interval
      end
    end
  end

  def stop!
    Thread.kill @thread
  end
end

checks = []
system.services.each do |service|
  checks << Check.new(service.name, service.check_interval, r, service.health)
  checks << Check.new("Host", service.host_check_interval, r, service.host_health)
  service.components.each do |component|
    checks << Check.new(component.name, service.check_interval, r, component.health)
  end
end

Thread.abort_on_exception=true
threads = checks.map(&:start!)
puts "Started #{threads.size} monitoring threads"
threads.map(&:join)
trap("SIGINT") { threads.map(&:stop!) }
