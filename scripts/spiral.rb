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

[:right, :back, :left, :front, :bottom].each do |pt|
  unless controller.points.include? pt
    puts "Can't do spiral since controller doesn't support #{pt}!"
    exit
  end
end

controller.buffer(:dimmer => 255)
controller.spiral_in
controller.spiral_out
controller.spiral_in
controller.spiral_out
