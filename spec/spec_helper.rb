require 'bundler'
Bundler.setup

require File.join(File.dirname(__FILE__), '../lib/ball_of_light') # require 'ball_of_light/ball_of_light'

if RUBY_VERSION.to_f == 1.9
  require 'simplecov'
  SimpleCov.start
end
