#!/usr/bin/env ruby
require 'thor'

class LighthouseAgent < Thor
  VERSION = 0.1
end

require_relative 'commands/check'

LighthouseAgent.start(ARGV)
