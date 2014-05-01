require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

class IntegrationTest
  include Capybara::DSL

  def initialize(host, driver = :poltergeist)
    Capybara.app_host = host
    Capybara.run_server = false
    Capybara.current_driver = driver
  end

  def run(&block)
    self.instance_eval &block
  end
end
