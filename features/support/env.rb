require 'aruba/cucumber'
require 'aruba/in_process'

require_relative '../../lib/runner'
Aruba::InProcess.main_class = Runner
Aruba.process = Aruba::InProcess

require 'webmock/cucumber'

Before do
  # speed up load time by skipping RubyGems
  set_env 'RUBYOPT', '--disable-gems' if RUBY_VERSION > '1.9'

  bin_dir = File.expand_path('../../bin', __FILE__)
  home_dir = File.expand_path('../../../tmp/aruba/', __FILE__)

  set_env 'EDITOR', "open"
  set_env 'PATH', "#{bin_dir}:#{ENV['PATH']}"
  set_env 'HOME', home_dir
end
