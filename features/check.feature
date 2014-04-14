Feature: baseline-agent check
  Scenario: With a valid service specification
    Given I have a valid service specification named "example-service.rb"
    When I run `baseline-agent check example-service.rb`
    Then the exit status should be 0

  Scenario: With an invalid service specification
    Given I have an invalid service specification named "invalid-service.rb"
    When I run `baseline-agent check invalid-service.rb`
    Then the exit status should be 1
    Then the output should contain "Invalid"

  Scenario: With the wrong filename
    When I run `baseline-agent check no-service.rb`
    Then the exit status should be 1
    Then the output should contain "File does not exist."
