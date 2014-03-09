require './dsl'
require 'json'

class Graph
  attr_accessor :nodes, :edges

  def initialize
    @nodes = []
    @edges = []
  end

  def add_nodes(node)
    @nodes << { id: @nodes.count, name: node }
    @nodes.count
  end

  def add_edges(from, to)
    @edges << { from: from, to: to, weight: 1 }
  end

  def to_json
    { nodes: @nodes, edges: @edges }.to_json
  end
end

system = DSL.load ARGV[0]
g = Graph.new 

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

puts g.to_json
