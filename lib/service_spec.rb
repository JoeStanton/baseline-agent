require 'yaml'
require 'erb'

class ServiceSpec
  attr_accessor :name, :components

  def initialize(name)
    @name = name
    @components = []
  end

  def load_definitions
    services = []
    categories = YAML.load_file 'lib/component_definitions.yml'
    categories.each do |category, components|
      components.each do |name, component|
        merged = { "type" => category, "name" => name }.merge(component)
        services << ComponentDefinition.new(merged)
      end
    end
    services
  end

  def detect!
    components = load_definitions
    @components = components.find_all(&:running?).each(&:detect_version!)
    self
  end

  def render
    base_path = File.expand_path(File.dirname(__FILE__))
    template = File.read "#{base_path}/service_spec.erb"
    ERB.new(template, 0, '>').result(binding)
  end
end

class ComponentDefinition
  attr_accessor(
    :name,
    :description,
    :type,
    :process,
    :ports,
    :version_cmd,
    :version,
    :path
  )

  def initialize(hash)
    @name = hash["name"]
    @type = hash["type"]
    @process = hash["process"]
    @description = hash["description"]
    @version_cmd = hash["version"]
    @path = hash["path"]
    @ports = hash["ports"]
    @check = hash["check"]
  end

  def running?
    `ps aux | grep "#{@process}" | grep -v grep`
    $?.success?
  end

  def detect_version!
    @version = `#{version_cmd}`.strip if @version_cmd
    self
  end
end

#component 'Nginx' do
  #description "Web Server"
  #version "1.4.0"

  #health do
    #running "nginx"
    #listening 80
    #listening 443
    #writable "/var/log/nginx/access.log"
    #writable "/var/log/nginx/error.log"
    #success? "http://localhost/"
  #end
#end

#component 'MongoDB' do
  #description "NoSQL document store"
  #health do
    #running "mongod"
    #listening 27017
  #end
#end
