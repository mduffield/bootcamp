ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'rack/test'
require 'rspec/expectations'
require 'webrat'
require 'webrat/selenium'

begin 
  require_relative '../../app.rb'
rescue NameError
  require File.expand_path('../../app.rb', __FILE__)
end

Webrat.configure do |config|
  config.mode = :rack
  config.application_framework = :sinatra
  config.application_port = 4567
end

class WebratMixinExample
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{WebratMixinExample.new}






