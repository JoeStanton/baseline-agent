require_relative '../lib/service_definition'

class LighthouseAgent
  desc :discover, "Creates a service definition from detected system services"

  def discover
    name = ask "Please enter a service name:"
    definitions = [
      { name: "Nginx", cmd: 'nginx', type: :webserver },
      { name: "ElasticSearch", cmd: 'elasticsearch', type: :database },
      { name: 'Redis', cmd: 'redis-server', type: :database },
      { name: 'MongoDB', cmd: 'mongod', type: :database },
      { name: 'RabbitMQ', cmd: 'rabbitmq', type: :queue },
    ]
    running = `ps aux`

    matches = []
    running.lines.each do |process|
      cmd = process.split[10]
      cmd = cmd.split('/').reverse.first
      match = definitions.select { |d| d[:cmd].include? cmd }.first
      matches << match if match
    end

    filename = "#{name.downcase.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.rb"
    File.open filename , 'w' do |f|
      f.write ServiceDefinition.new(name, matches).render
    end

    pid = spawn "$EDITOR #{filename}"
    Process.wait(pid)
  end
end
