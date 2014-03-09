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

  desc :validate, "Validates a system definition"
  def validate(system)
    load_system(system)
    puts "Valid".green
  rescue Errno::ENOENT => e
    puts "File does not exist.".red
  rescue => e
    puts "Invalid : #{e.message}".red
  end

  no_commands do
    def load_system(system)
      @system = DSL.load system
    end
  end
end

require_relative 'commands/setup'
require_relative 'commands/check'
require_relative 'commands/discover'

LighthouseAgent.start(ARGV)
