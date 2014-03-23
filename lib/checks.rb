require 'ruby-units'
require 'open_uri_redirections'

module Checks
  def self.execute(&block)
    self.instance_eval &block
  end

  def self.success(url, options={})
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host ,uri.port)

    http.use_ssl = url =~ %r{\Ahttps://}
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.open_timeout = options[:timeout] || 10

    http.start do |http|
      req = Net::HTTP::Head.new(uri.request_uri)
      req['User-Agent'] = "LighthouseAgent"
      req['Host'] = uri.host

      if uri.user && uri.password
        req.basic_auth uri.user, uri.password
      end
      response = http.request(req)
      response.kind_of?(Net::HTTPSuccess) || response.kind_of?(Net::HTTPRedirection)
    end
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
