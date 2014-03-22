require 'yaml'
PATH = "#{Dir.home}/.lighthouse"

class Configuration
  attr_accessor :management_server

  def initialize(params)
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params
  end

  def save
    system 'mkdir', '-p', PATH
    File.open("#{PATH}/config.yml", 'w') {|f| f.write self.to_yaml }
  end

  def self.load
    if File.exists?("#{PATH}/config.yml")
      config = File.read("#{PATH}/config.yml")
      YAML.load(config)
    else
      Configuration.new({})
    end
  end
end
