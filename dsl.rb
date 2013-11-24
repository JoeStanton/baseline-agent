require 'docile'

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
end

class Service < Node
  attr_accessor :components

  def initialize(name)
    super
    @components = []
  end

  def health(&block)
    @health = block
  end

  def healthy?
    @health.call if @health
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

# DSL entry point
def service(name, &block)
  instance = Service.new(name)
  Docile.dsl_eval instance, &block if block_given?
  instance
end
