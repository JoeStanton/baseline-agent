require './dsl'
require 'colorize'

system = DSL.load ARGV[0]

def success?(url)
  true
end

def response_time(url)
  '1s'
end

def redis_key_size
  1000
end

def healthy_to_s(status)
  case status 
  when true
    'Healthy'.green 
  when nil
    'Unknown'.yellow
  when false
    'Error'.red
  end
end

system.services.each do |service|
  puts "checking service #{service.name} : #{healthy_to_s(service.healthy?)}"

  service.components.each do |component| 
    puts "   checking #{component.name} : #{healthy_to_s(component.healthy?)}"
  end
end
