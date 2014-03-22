require 'ruby-units'

module Checks
  def self.execute(&block)
    self.instance_eval &block
  end

  def self.success(url)
    open url
    true
  rescue Exception => e
    false
  end

  def self.listening(port)
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new("127.0.0.1", port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
    false
  end

  def self.cpu_load_average
    0.9
  end

  def self.memory_usage
    Unit('51MB')
  end

  def self.disk_usage(mount = "/")
    `df -P`.lines.each do |r|
      f = r.split(/\s+/)
      if f[5] == mount
        return Unit.new(f[4])
      end
    end
  end

  def self.response_time(url)
    '1s'
  end

  def self.running(process)
    `pgrep -f "#{process}"`
    $?.success?
  end
end
