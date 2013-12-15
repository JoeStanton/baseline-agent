require 'simplecov'
SimpleCov.start

require 'rspec'
require './dsl'

def parse(&block)
  DSL.parse &block
end

describe 'System' do
  it 'should keep track of declared services' do
    example = nil
    system = parse {
      example = service 'Workspace +'
    }
    system.services.should == [ example ]
  end
end

describe 'Service' do
  it 'should be specified with a name' do
    example = nil
    parse {
      example = service 'Workspace +'
    }
    example.should be_a Service
    example.name.should == 'Workspace +'
  end

  it 'should take a description' do
    example = nil
    parse {
      example = service 'Workspace+' do
        description 'Example service'
      end
    }
    example.description.should == 'Example service'
  end

  it 'should take and execute a health check' do
    example = nil
    parse {
      example = service 'Workspace+' do
        health do
          true
        end
      end
    }
    example.healthy?.should == true
  end

  it 'should take dependencies' do
    example = nil
    parse {
      example = service 'Workspace +' do
        dependency 'Sharepoint API'
        dependency 'ADFS Authentication'
      end
    }

    example.dependencies.should == ['Sharepoint API', 'ADFS Authentication']
  end

  it 'should take components' do
    example = nil
    parse {
      example = service 'Workspace +' do
        component 'Web Server'
        component 'Application'
      end
   }

    example.components.should have(2).items
    example.components.first.should be_a Component
    example.components.first.name.should == 'Web Server'
  end
end

describe 'Component' do
  it 'should take a description' do
    example = nil
    parse {
      example = service 'Workspace +' do
        component 'Web Server' do
          description 'Reverse proxy the app'
        end
      end
    }

    example.components.first.description.should == 'Reverse proxy the app'
  end

  it 'should take a private port' do
    example = nil
    parse {
      service 'Workspace +' do
        example = component 'Web Server' do
          description 'Reverse proxy the app'
          listen 8000
        end
      end
    }

    example.private_ports.should == [8000]
  end

  it 'should take a private port' do
    example = nil
    parse {
      service 'Workspace +' do
        example = component 'Web Server' do
          description 'Reverse proxy the app'
          public_listen 80
        end
      end
    }

    example.public_ports.should == [80]
  end

  it 'should take and execute a health check' do
    example = nil
    parse {
      service 'Workspace+' do
        example = component 'Web Server' do
          health do
            true
          end
        end
      end
    }
    example.healthy?.should == true
  end

  it 'should take dependencies' do
    example = nil
    parse {
      example = service 'Workspace +' do
        component 'Web Server' do
          dependency 'Application'
          dependency 'OS'
        end
      end
    }

    app = example.components.first
    app.dependencies.should == ['Application', 'OS']
  end
end
