require 'socket'
require_relative 'string_helpers'

class Check
  attr_reader :thread

  def initialize(opts)
    @name = opts[:name] or raise 'Checks must have a name'
    @check = opts[:check] or raise 'Check must be specified as a proc'
    @client = opts[:client] or raise 'Checks must be passed a valid client'
    @type = opts[:type] || 'check'
    @interval = opts[:interval] || 30
    @host = opts[:host] || Socket.gethostname
    @service = opts[:service]
    @component = opts[:component]
  end

  def report(status)
    @client << {
      host: @host,
      service: @service,
      component: @component,
      description: @name,
      state: status ? 'ok' : 'error',
      metric: status ? 1 : 0,
      type: @type,
      tags: ['check'],
      notify_endpoint: notify_endpoint,
      ttl: @interval*2
    }
  end

  def notify_endpoint
    case @type
    when :host
      "/hosts/#{@host}"
    when :service
      "/services/#{StringHelpers.slugify(@service)}"
    when :component
      "/services/#{StringHelpers.slugify(@service)}/components/#{StringHelpers.slugify(@component)}"
    end
  end

  def start!
    @thread = Thread.new do
      while true
        report(Checks.execute(&@check))
        sleep @interval
      end
    end
  end

  def stop!
    Thread.kill @thread
  end
end
