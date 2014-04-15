require 'thor'
require 'colorize'

require_relative '../lib/configuration'
require_relative '../lib/dsl'
require_relative '../lib/string_helpers'

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

