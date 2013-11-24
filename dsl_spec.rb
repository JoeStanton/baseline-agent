require 'rspec'
require './dsl'

describe 'DSL' do
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
end
