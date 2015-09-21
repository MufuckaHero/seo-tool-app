ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'
Bundler.require

require ::File.expand_path('../lib/app',  __FILE__)

run Seo::App
