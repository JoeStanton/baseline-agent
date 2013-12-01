require './dsl'
require 'graphviz'

system = DSL.load ARGV[0]
g = GraphViz.new( :G, :type => :digraph )

dict = {}

system.services.each do |service|
  dict[service.name] = g.add_nodes service.name

  service.components.each do |component|
    dict[component.name] = g.add_nodes component.name
  end
end

system.services.each do |service|
  service.dependencies.each do |dep|
    raise "Unresolved dependency #{service.name}->#{dep}" unless dict[dep]
    g.add_edges dict[service.name], dict[dep]
  end

  service.components.each do |component|
    component.dependencies.each do |dep|
      raise "Unresolved dependency #{component.name}->#{dep}" unless dict[dep]
      g.add_edges dict[component.name], dict[dep]
    end
  end
end

g.output( :png => "graph.png" )
