require 'aruba/cucumber'
require 'aruba/in_process'

require 'simplecov'
SimpleCov.start
SimpleCov.use_merging true

require_relative '../../bin/runner'
Aruba::InProcess.main_class = Runner
Aruba.process = Aruba::InProcess

require 'webmock/cucumber'

Before do
  bin_dir = File.expand_path('../../bin', __FILE__)
  home_dir = File.expand_path('../../../tmp/aruba/', __FILE__)

  set_env 'EDITOR', 'open'
  set_env 'PATH',  "#{bin_dir}:#{ENV['PATH']}"
  set_env 'HOME', home_dir
end
