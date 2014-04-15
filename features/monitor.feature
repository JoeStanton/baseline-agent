Feature: baseline-agent monitor
  Scenario: Start monitoring
    When I run `baseline-agent start example-service.rb`
    Then the exit status should be 1
    Then the output should contain "Must run as root"
