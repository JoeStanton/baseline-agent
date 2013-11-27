require './dsl'
require 'colorize'

system = DSL.load ARGV[0]

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
