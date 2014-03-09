require 'erb'
class ServiceDefinition
  attr_reader :name, :components

  def initialize(name, components)
    @name = name
    @components = components
  end

  def render
    template = File.read 'lib/service_definition.erb'
    ERB.new(template).result(binding)
  end
end
