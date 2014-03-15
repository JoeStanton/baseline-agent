#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require 'thor'
require 'colorize'

require_relative 'lib/configuration'
require_relative 'lib/dsl'

Bundler.setup

class LighthouseAgent < Thor
  VERSION = 0.1

  no_commands do
    def load_system(system)
      @system = DSL.load system
    end
  end
end

require_relative 'commands/validate'
require_relative 'commands/setup'
require_relative 'commands/check'
require_relative 'commands/monitor'
require_relative 'commands/discover'
require_relative 'commands/push'

LighthouseAgent.start(ARGV)
