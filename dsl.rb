require 'docile'
require 'ruby-units'
require 'open-uri'

def success?(url)
  open url
  true
rescue Exception => e
  false
end

def cpu_usage
  Unit('50%')
end

def memory_usage
  Unit('51MB')
end

def response_time(url)
  '1s'
end

def redis_key_size
  1000
end

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

class Node
  attr_accessor :name, :dependencies

  def initialize(name)
    @name = name
    @dependencies = []
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

  def health(&block)
    @health = block
  end

  def healthy?
    @health.call if @health
  end
end

class Service < Node
  attr_accessor :components

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
end
