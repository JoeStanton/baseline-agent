require 'yaml'

class Configuration
  attr_accessor :management_server

  def initialize(params)
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params
  end

  def save
    File.open('./config.yml', 'w') {|f| f.write self.to_yaml }
  end

  def load
    config = File.read('./config.yml')
    YAML.load(config)
  end
end
