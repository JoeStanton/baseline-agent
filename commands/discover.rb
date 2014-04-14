require_relative '../lib/service_spec'

class BaselineAgent
  desc :discover, "Creates a service definition from detected system services"

  def discover
    name = ask "Please enter a service name:"
    error "you must enter a service name" unless name

    filename = "#{name.downcase.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.rb"

    content = ServiceSpec.new(name).detect!.render
    File.write filename, content

    pid = spawn "$EDITOR #{filename}"
    Process.wait(pid)
  end
end
