require 'docile'

class Service
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def description(value = nil)
    if value
      @description = value
    else
      @description
    end
  end

  def health(&block)
    @health = block
  end

  def healthy?
    @health.call if @health
  end
end

def service(name, &block)
  instance = Service.new(name)
  Docile.dsl_eval instance, &block if block_given?
  instance
end
