Feature: baseline-agent discover
  Scenario: Service Discovery
    When I run `baseline-agent discover "example service"`
    Then the exit status should be 0
    Then a file named "example_service.rb" should exist
    Then the file "example_service.rb" should contain "service 'example service'"
