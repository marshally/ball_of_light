#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require_relative '../lib/ball_of_light'

# This script is for:
# If no one is in the field

options = {}
if ENV['TEST']
  options.merge!(:cmd => "xargs -n1 echo")
end

# setup controller
controller = BallOfLight::BallOfLightController.new(options)
controller.on!

count = 9
if ENV["SHORT"]=="true"
  count=1
end

# runs for about 90 seconds
count.times do |i|
  puts "factory #{i}"
  # 5s
  # pan left to right 100% of rotation
  [0,255].each do |p|
    controller.buffer(:point => controller.random_color)
    controller.animate!(:seconds => 5, :pan => p)
    controller.buffer(:point => controller.random_color)
    controller.animate!(:seconds => 0.5, :tilt => rand(255).to_i)

    # check the input pipe for kill condition?
  end
end
