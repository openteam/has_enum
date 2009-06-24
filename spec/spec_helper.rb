ENV['RAILS_ENV'] = 'test'

rails_root = File.dirname(__FILE__) + '/rails_root'
require "#{rails_root}/config/environment.rb"

require File.dirname(__FILE__) + "/model" unless defined?(Model)

require 'spec'
require 'spec/rails'
