require 'bundler'
Bundler.setup

if RUBY_VERSION.to_f == 1.9
  require 'simplecov'
  SimpleCov.start
end

require 'ball_of_light'
