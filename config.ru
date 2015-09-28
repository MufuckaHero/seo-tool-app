ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'
Bundler.require

require ::File.expand_path('../lib/app',  __FILE__)

module Rack
  class Lint
    def assert message, &block
    end
  end
end

run Seo::App
