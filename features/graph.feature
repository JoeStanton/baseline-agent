Feature: baseline-agent graph
  Scenario: Graphing
    Given I have a valid service specification named "abc.rb"
    When I run `baseline-agent graph abc.rb`
    Then the exit status should be 0
    Then a file named "abc.pdf" should exist
