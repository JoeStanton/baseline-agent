require 'thor'
require 'colorize'

require_relative './configuration'
require_relative './dsl'
require_relative './string_helpers'

class BaselineAgent < Thor
  VERSION = 0.1
  def self.exit_on_failure?
    true
  end

  no_commands do
    def load_system(system)
      @system = DSL.load system
    rescue Errno::ENOENT => e
      error "File does not exist."
    rescue => e
      error "Invalid : #{e.message}"
    end

    def error(message)
      raise Thor::Error.new(message.red)
    end

    def require_root!
      error 'Must run as root (or use sudo)' unless Process.uid == 0
    end

    def require_setup!
      error 'Agent not linked to a management server, please run the "setup" command' unless Configuration.load.management_server
    end
  end
end

require_relative '../commands/setup'
require_relative '../commands/check'
require_relative '../commands/graph'
require_relative '../commands/monitor'
require_relative '../commands/discover'
require_relative '../commands/push'
require_relative '../commands/pull'
require_relative '../commands/event'
require_relative '../commands/events/config'
require_relative '../commands/events/deploy'

class Runner
  # Allow everything fun to be injected from the outside while defaulting to normal implementations.
  def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    exit_code = begin
      # Thor accesses these streams directly rather than letting them be injected, so we replace them...
      $stderr = @stderr
      $stdin = @stdin
      $stdout = @stdout

      # Run our normal Thor app the way we know and love.
      BaselineAgent.start(@argv)

      0
    rescue SystemExit
      1
    ensure
      # ...then we put them back.
      $stderr = STDERR
      $stdin = STDIN
      $stdout = STDOUT
    end

    # Proxy our exit code back to the injected kernel.
    @kernel.exit(exit_code)
  end
end
