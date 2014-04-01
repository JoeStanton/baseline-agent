require 'docile'
require 'open-uri'

require 'socket'
require 'timeout'

require_relative './checks'

class DSL
  def self.load(file)
    system = System.new
    dsl = File.read file
    system.instance_eval dsl, file
    system
  end

  def self.parse(&block)
    system = System.new
    system.instance_eval &block
    system
  end
end

class System
  attr_accessor :services

  def initialize
    @services = []
  end

  # DSL entry point
  def service(name, &block)
    instance = Service.new(name)
    Docile.dsl_eval instance, &block if block_given?
    services << instance
    instance
  end
end

require 'hashifiable'
class Node
  attr_accessor :name, :dependencies, :check_interval, :host_check_interval

  extend Hashifiable

  def initialize(name)
    @name = name
    @dependencies = []
    @private_ports = []
    @public_ports = []
  end

  def description(value = nil)
    if value
      @description = value
    else
      @description
    end
  end

  def dependency(name)
    @dependencies << name
  end

  def host_health(options = {}, &block)
    if block_given?
      @host_check_interval = options[:interval] || 30
      @host_health = block
    else
      @host_health
    end
  end

  def host_healthy?
    Checks.execute(&@host_health) if @host_health
  end

  def health(options = {}, &block)
    if block_given?
      @check_interval = options[:interval] || 30
      @health = block
    else
      @health
    end
  end

  def healthy?
    Checks.execute(&@health) if @health
  end
end

class Service < Node
  attr_accessor :components
  hashify :name, :description, components: -> { components.map(&:to_hash) }

  def initialize(name)
    super
    @components = []
  end

  def component(name, &block)
    instance = Component.new(name)
    Docile.dsl_eval instance, &block if block_given?
    components << instance
    instance
  end
end

class Component < Node
  attr_accessor :private_ports, :public_ports
  hashify :name, :description

  def listen(port)
    @private_ports << port
  end

  def public_listen(port)
    @public_ports << port
  end
end
