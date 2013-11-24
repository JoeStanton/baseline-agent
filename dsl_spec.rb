require 'rspec'
require './dsl'

describe 'DSL' do
  describe 'Service' do
    it 'should allow the declaration of a service' do
      example = service 'JLT Workspace +'
      example.should be_a Service
      example.name.should == 'JLT Workspace +'
    end

    it 'should take a description' do
      example = service 'JLT Workspace+' do
        description 'Example service'
      end
      example.description.should == 'Example service'
    end

    it 'should take and execute a health check' do
      example = service 'JLT Workspace+' do
        health do
          true
        end
      end
      example.healthy?.should == true
    end

    it 'should take components' do
      example = service 'JLT Workspace +' do
        component 'Web Server'
        component 'Application'
      end

      example.components.should have(2).items
      example.components.first.should be_a Component
      example.components.first.name.should == 'Web Server'
    end
  end

  describe 'Component' do
    it 'should take a description' do
      example = service 'JLT Workspace +' do
        component 'Web Server' do
          description 'Reverse proxy the app'
        end
      end

      example.components.first.description.should == 'Reverse proxy the app'
    end
  end
end
