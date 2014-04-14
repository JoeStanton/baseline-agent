Feature: baseline-agent pull
  #Scenario: Pulling without management server
    #When I run `baseline-agent pull example-service`
    #Then the exit status should be 1
    #Then the output should contain "Agent not linked to a management server"

  #Scenario: Pulling a non-existant service
    #Given A management server
    #When I run `baseline-agent pull example-service`
    #Then the output should contain "service does not exist."
    #Then the exit status should be 1

  #Scenario: Pulling a valid service
    #Given A management server
    #Given The service "example-service" with spec:
       #"""
       #service 'example-service'
       #"""
    #When I run `baseline-agent pull example-service`
    #Then the exit status should be 0
    #Then the output should contain "service does not exist."
