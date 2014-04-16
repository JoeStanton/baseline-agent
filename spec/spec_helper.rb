require 'rubygems'
require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'webmock/rspec'
require_relative '../commands/main'
