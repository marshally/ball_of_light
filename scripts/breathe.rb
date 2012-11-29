#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require_relative '../lib/ball_of_light'


options = {}
if ENV['TEST']
  options.merge!(:cmd => "xargs -n1 echo")
end

# setup controller
controller = BallOfLight::BallOfLightController.new(options)

controller.origin!

count = 20

if ENV["SHORT"]!="true"
  count = 2
end

count.times do
  controller.breathe(rand(10)+5)
end
