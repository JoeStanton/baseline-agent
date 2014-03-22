require 'erb'
class ServiceDefinition
  attr_reader :name, :components

  def initialize(name, components)
    @name = name
    @components = components
  end

  def render
    base_path = File.expand_path(File.dirname(__FILE__))
    template = File.read "#{base_path}/service_definition.erb"
    ERB.new(template).result(binding)
  end
end
