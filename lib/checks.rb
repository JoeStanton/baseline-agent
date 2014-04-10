require 'ruby-units'
require 'open_uri_redirections'

module Checks
  def self.execute(&block)
    self.instance_eval &block
    [true, "Passed"]
  rescue Exception => e
    [false, e.message]
  end

  def self.success(url, options={})
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host ,uri.port)

    http.use_ssl = url =~ %r{\Ahttps://}
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.open_timeout = options[:timeout] || 15

    http.start do |http|
      req = Net::HTTP::Head.new(uri.request_uri)
      req['User-Agent'] = "Baseline Agent"
      req['Host'] = uri.host

      if uri.user && uri.password
        req.basic_auth uri.user, uri.password
      end

      response = http.request(req)
      unless response.kind_of?(Net::HTTPSuccess) || response.kind_of?(Net::HTTPRedirection)
        fail "Unexpected response #{response.class}" 
      end
    end
  end

  def self.listening(port)
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new("127.0.0.1", port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        fail "Socket connection refused"
      end
    end
  rescue Timeout::Error
    fail "Socket timed out"
  end

  def self.cpu_load_average
    0.9
  end

  def self.process_cpu_load(process)
    process_info(process)[:cpu_percentage]
  end

  def self.memory_usage(process)
    process_info(process)[:resident_set]
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
    `ps aux | grep "#{process}" | grep -v grep`
    fail "Process #{process} not running" unless $?.success?
    true
  end

  def self.process_info(process)
    output = `ps aux | grep #{process} | grep -v grep`
    raise "Process #{process} has #{output.lines.length} matches" unless output.lines.length == 1
    parts = output.split(/\s+/)
    {
      user: parts[0],
      pid: parts[1],
      cpu_percentage: Unit.new(parts[2] + "%"),
      memory_percentage: Unit.new(parts[3] + "%"),
      virtual_size: Unit.new(parts[4] + " kb"),
      resident_set: Unit.new(parts[5] + " kb"),
      process_name: parts[10]
    }
  end
end
