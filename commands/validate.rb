class LighthouseAgent
  desc :validate, "Validates a system definition"
  def validate(system)
    load_system(system)
    puts "Valid".green
  rescue Errno::ENOENT => e
    puts "File does not exist.".red
  rescue => e
    puts "Invalid : #{e.message}".red
  end
end
