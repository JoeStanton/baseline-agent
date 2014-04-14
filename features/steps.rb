require 'yaml'

Given("A management server") do
  create_dir ".baseline"
  write_file ".baseline/config.yml", """
--- !ruby/object:Configuration
management_server: http://fake-host.local
  """
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
