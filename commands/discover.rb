require_relative '../lib/service_spec'

class LighthouseAgent
  desc :discover, "Creates a service definition from detected system services"

  def discover
    name = ask "Please enter a service name:"
    filename = "#{name.downcase.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.rb"

    File.open filename , 'w' do |f|
      f.write ServiceSpec.new(name).detect!.render
    end

    pid = spawn "$EDITOR #{filename}"
    Process.wait(pid)
  end
end
