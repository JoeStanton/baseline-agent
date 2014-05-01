# baseline-agent
[![Build Status](https://travis-ci.org/JoeStanton/baseline-agent.png)](https://travis-ci.org/JoeStanton/baseline-agent)
[![Code Climate](https://codeclimate.com/github/JoeStanton/baseline-agent.png)](https://codeclimate.com/github/JoeStanton/baseline-agent)

Baseline provides a Ruby based DSL to describe and validate your
infrastructure. You can use this in association with the [Baseline API](https://github.com/JoeStanton/baseline-api)
and [Baseline Web UI](https://github.com/JoeStanton/baseline-web)

## Installation

Via a management server:

With curl: `curl -s https://management-server/agent/install | bash`  
With wget: `wget -q -O- https://management-server/agent/install | bash`

## DSL

Baseline provides a Ruby based DSL to describe and validate your
infrastructure. It looks like this:

```ruby
service "Resource Planner" do
  description "Internal project resourcing & forecasting tool"
  health { success "https://127.0.0.1" }
  dependency "Nginx"

  host_health(interval: 30) do
    disk_usage < "80%" or fail "Disk too full"
  end

  component "Nginx" do
    description "Reverse proxy and static asset web server"
    dependency "Ruby on Rails (Unicorn)"
    health(interval: 15) do
      running "nginx"
      listening 80
    end
  end

  component "Ruby on Rails (Unicorn)" do
    description "Multi-process Ruby application server"
    dependency "Redis"
    dependency "Postgres"
    dependency "FreeAgent API"
    health(interval: 10) do
      running "unicorn master"
      running "unicorn worker"
    end
  end

  component "Redis" do
    description "Session state storage"
    health(interval: 10) do
      running "redis-server"
      listening 6379
    end
  end

  component "Postgres" do
    description "Relational database storing all entities"
    health(interval: 10) do
      running "postgres"
      listening 5432
    end
  end

  component "FreeAgent API" do
    description "Source of users, projects & timesheet data"
    health(interval: 360) do
      success "http://www.freeagent.com/", timeout: 30
    end
  end
end
```

## Usage

```
Commands:
  baseline-agent check                                                     # Run configured health checks
  baseline-agent discover                                                  # Creates a service definition from detected system services
  baseline-agent event:config --description=DESCRIPTION --service=SERVICE  # Create a configuration event
  baseline-agent event:deploy --service=SERVICE                            # Create a deployment event
  baseline-agent graph                                                     # Render a graph of the current service
  baseline-agent help [COMMAND]                                            # Describe available commands or one specific command
  baseline-agent pull                                                      # Pull the specified service spec from the management server
  baseline-agent push                                                      # Pushes the specified service to a management server
  baseline-agent restart                                                   # Restart monitoring the specified service
  baseline-agent setup                                                     # Register this host with the management server
  baseline-agent start                                                     # Continuously monitor the specified service
  baseline-agent stop                                                      # Stop monitoring the specified service
```
