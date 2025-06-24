#!/usr/bin/env ruby
require 'bundler/setup'
require 'omniauth/strategies/square'

# Mock the necessary environment
class MockApp
  def call(env)
    [200, {}, ['Hello World']]
  end
end

class MockRequest
  def initialize
    @env = {
      'rack.session' => {},
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/auth/square',
      'rack.url_scheme' => 'http',
      'HTTP_HOST' => 'localhost:3000'
    }
  end

  def env
    @env
  end

  def params
    {}
  end

  def scheme
    'http'
  end

  def url
    'http://localhost:3000/auth/square'
  end
end

# Test without session parameter
puts "Testing without session parameter:"
strategy = OmniAuth::Strategies::Square.new(MockApp.new)
request = MockRequest.new
strategy.instance_variable_set(:@env, request.env)
params = strategy.authorize_params
puts "Has session param: #{params.key?(:session)}"
puts "Session value: #{params[:session]}" if params.key?(:session)

# Test with session: false
puts "\nTesting with session: false:"
strategy = OmniAuth::Strategies::Square.new(MockApp.new, {session: false})
request = MockRequest.new
strategy.instance_variable_set(:@env, request.env)
params = strategy.authorize_params
puts "Has session param: #{params.key?(:session)}"
puts "Session value: #{params[:session]}" if params.key?(:session)

# Test with session: true (should not include session param)
puts "\nTesting with session: true:"
strategy = OmniAuth::Strategies::Square.new(MockApp.new, {session: true})
request = MockRequest.new
strategy.instance_variable_set(:@env, request.env)
params = strategy.authorize_params
puts "Has session param: #{params.key?(:session)}"
puts "Session value: #{params[:session]}" if params.key?(:session)

puts "\nAll params for session: false case:"
strategy = OmniAuth::Strategies::Square.new(MockApp.new, {session: false})
request = MockRequest.new
strategy.instance_variable_set(:@env, request.env)
params = strategy.authorize_params
puts params.inspect