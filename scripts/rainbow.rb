#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require_relative '../lib/ball_of_light'

# This script is for:
# If no one is in the field

options = {:count => 6}
if ENV['TEST']
  options.merge!(:cmd => "xargs -n1 echo")
end

# setup controller
controller = BallOfLight::BallOfLightController.new(options)

#####################################################################

controller.tilt(127)
controller.pan!(0)
sleep(5)

controller.colors.each do |c|
  controller.begin_animation! do |devices|
    devices
  end
end
