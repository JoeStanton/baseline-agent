require 'yaml'
require 'cucumber/rspec/doubles'

Given("A management server") do
  create_dir ".baseline"
  write_file ".baseline/config.yml", """
--- !ruby/object:Configuration
management_server: http://fake-host.local
  """
end

Given(/^a mock API$/) do
  stub_request(:any, /.*fake-server.*/).to_return(body: {})
end

Given(/^The hostname is "(.*?)"$/) do |hostname|
  Socket.should_receive(:gethostname).and_return(hostname)
end

Given(/^I have a valid service specification named "(.*?)"$/) do |file|
  write_file file, "service 'abc'"
end

Given(/^I have an invalid service specification named "(.*?)"$/) do |file|
  write_file file, """
    service 'abc' do
      invalid_prop
    end
  """
end

Given(/^a git repo "(.*?)"$/) do |name|
  run_simple "git init #{name}"
  cd name
  run_simple "git remote add origin https://github.com/TestUser/test-repo.git"
end
