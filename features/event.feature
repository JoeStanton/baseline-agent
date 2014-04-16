Feature: baseline-agent event
  Scenario: Deployment
    Given a git repo "git-repo"
    And a mock API
    When I run `baseline-agent event:deploy --service=example-service`
    Then the exit status should be 0
