require 'socket'

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
