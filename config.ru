ENV['RACK_ENV'] = "development"

require 'rubygems'
require 'sinatra'
require File.expand_path("../app", __FILE__)

set :protection, :except => [:remote_token, :frame_options]

run Sinatra::Application
