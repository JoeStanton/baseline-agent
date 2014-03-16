require './lib/graph'

class LighthouseAgent
  desc :graph, 'Render a graph of the current service'
  def graph(system)
    system = load_system(system)
    file = "#{StringHelpers.slugify(system.services.first.name)}.pdf"
    Graph.new(system).render(file)
    `which open && open #{file}`
  end
end
