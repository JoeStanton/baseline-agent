Feature: baseline-agent setup
  Scenario: Setup
    Given A mock management server "https://fake-server.com"
    Given The hostname is "test-host"
    When I run `baseline-agent setup https://fake-server.com`
    Then a put API request to "https://fake-server.com/hosts/test-host" should be made
    Then the exit status should be 0
    Then the management server should be "https://fake-server.com"
