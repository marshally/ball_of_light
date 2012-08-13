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

# runs for about 90 seconds
#9.times do
9.times do |i|
  puts "factory #{i}"
  # 5s
  # pan left to right 100% of rotation
  controller.buffer(:point => controller.random_color)
  controller.animate!(:seconds => 5, :pan => 0)
  controller.buffer(:point => controller.random_color)
  controller.animate!(:seconds => 0.5, :tilt => rand(255).to_i)
  controller.animate!(:seconds => 5, :pan => 255)
  controller.buffer(:point => controller.random_color)
  controller.animate!(:seconds => 0.5, :tilt => rand(255).to_i)
end
# 5s
# tilt 25% of rotation, random direction
# change gobo light
