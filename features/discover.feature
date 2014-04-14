Feature: baseline-agent discover
  Scenario: Service Discovery
    When I run `baseline-agent discover` interactively
    And I type "example service"
    And I type ""
    Then the exit status should be 0
    Then a file named "example_service.rb" should exist
    Then the file "example_service.rb" should contain "service 'example service'"
