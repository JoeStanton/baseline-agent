require 'spec_helper'
require 'checks'

describe Checks do
  describe "#execute" do
    it "should return a pass tuple when the check completes successfully" do
      result, _ = Checks.execute { true }
      result.should be_true
    end

    it "should swallow exceptions and return a fail tuple with details" do
      result, message = Checks.execute { fail 'A failed assertion' }
      result.should be_false
      message.should == 'A failed assertion'
    end
  end

  describe "running check" do
    it "passes when the process is running" do
      result = Checks.execute { running "." }
      result.should be_true
    end

    it "fails when the process isnt running" do
      result, message = Checks.execute { running "nonexistantproc" }
      result.should be_false
      message.should == "Process nonexistantproc not running"
    end
  end

  describe "listening check" do
    it "passes when the TCP socket opens" do
      server = double('server').as_null_object
      TCPSocket.stub(:new).and_return(server)

      result = Checks.execute { listening 1234 }
      result.should be_true
    end

    it "fails when the TCP socket is refused" do
      TCPSocket.stub(:new).and_raise(Errno::ECONNREFUSED)

      result, message = Checks.execute { listening 1234 }
      result.should be_false
      message.should == "Socket connection refused"
    end

    it "fails when the TCP socket times out" do
      Timeout.stub(:timeout).and_raise(Timeout::Error)

      result, message = Checks.execute { listening 1234 }
      result.should be_false
      message.should == "Socket timed out"
    end
  end

  describe "process_info helper" do
    it "should parse ps aux correctly" do
      Checks.should_receive(:`).and_return("Joe  400   0.0  0.2  2097152  17492   ??  S    11:21pm   0:04.63 process_name")
      process = Checks.process_info('sample')
      process[:user].should == "Joe"
      process[:pid].should == "400"
      process[:cpu_percentage].should == "0.0 %"
      process[:memory_percentage].should == "0.2%"
      process[:virtual_size].should be_within("100Mb").of "2Gb"
      process[:resident_set].should be_within("1Mb").of "17Mb"
      process[:process_name].should == "process_name"
    end
  end

  describe "disk_usage check" do
    it "should extract the usage as a Unit" do
      Checks.should_receive(:`).twice.and_return("""
Filesystem    512-blocks      Used Available Capacity  Mounted on
/dev/disk1     487900168 433215576  54172592    89%    /
devfs                430       430         0   100%    /dev
       """)

      Checks.disk_usage.should == "89%"
      Checks.disk_usage("/dev").should == "100%"
    end
  end

  describe "process_cpu_load" do
    it "should return the CPU percentage as a unit" do
      Checks.should_receive(:`).and_return("Joe  400   0.0  0.2  2097152  17492   ??  S    11:21pm   0:04.63 process_name")
      Checks.process_cpu_load('sample').should == "0.0 %"
    end
  end

  describe "memory_usage" do
    it "should return memory usage for the given process as a unit" do
      Checks.should_receive(:`).and_return("Joe  400   0.0  0.2  2097152  17492   ??  S    11:21pm   0:04.63 process_name")
      Checks.memory_usage('sample').should be_within("1Mb").of "17Mb"
    end
  end


  #describe "HTTP success check" do
  #it "passes when the request is successful" do
  #result = Checks.execute {  "." }
  #result.should be_true
  #end

  #it "fails when the process isnt running" do
  #result, message = Checks.execute { running "nonexistantproc" }
  #result.should be_false
  #message.should == "Process nonexistantproc not running"
  #end
  #end
end
