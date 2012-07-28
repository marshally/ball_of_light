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

# Send the exact same command to all lights for this series:
# Point toward the center for 30 seconds.

# This command turns the light on
controller.set(:dimmer => 255)
controller.set(:pan => 127, :tilt => 127)
controller.set(:point => :center)
controller.center # you can call named points as if they are methods. This queues up the command
controller.write! # this sends whatever is in the buffer

controller.nocolor! # this sends the named point instantly

# Cycle through each color with .5 sec/color.
controller.bottom!

[:yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings].each do |color|
  controller.instant!(:point => color)
  sleep(0.5)
end

#turn the color off first
controller.set(:gobo => 0) #nocolor # turn the color off first

# Strobe for a second and point at the ground
controller.strobe_fast
controller.bottom!
# or controller.instant!(:tilt => 80)

# Have all lights sweep slowly back and forth for 30 sec, cycling through the colors. The lights have a greater range in one axis, so sweep in that direction. Return to center when complete.
3.times do
  # back 5 seconds
  controller.transition!(:seconds => 2.5, :pan => 0, :gobo => 8)
  # forward 5 seconds
  controller.transition!(:seconds => 2.5, :pan => 255, :gobo => 57)
end

# back to center
controller.transition!(:seconds => 2, :pan => 0, :tilt => 80)

# Have all lights inscribe a slow spiral, terminating in a circle, as wide as the hardware allows. Curved spirals are hard to program, so you can do an easy square spiral with a couple of do loops. Continue cycling between colors with each loop. (or substitute a cooler routine.)
# NOTE: this is more of a circle?
controller.transition!(:seconds => 2.5, :tilt => 55, :pan => 255)
controller.transition!(:seconds => 2.5, :tilt => 30, :pan => 255)
controller.transition!(:seconds => 2.5, :tilt => 55, :pan => 255)
controller.transition!(:seconds => 2.5, :tilt => 80, :pan => 255)

# Put all lights in automatic light routine for 30 seconds
# MCY: not sure what this means?

# Do the spiral in reverse.
controller.transition!(:seconds => 2.5, :tilt => 80, :pan => 255)
controller.transition!(:seconds => 2.5, :tilt => 55, :pan => 255)
controller.transition!(:seconds => 2.5, :tilt => 30, :pan => 255)
controller.transition!(:seconds => 2.5, :tilt => 55, :pan => 255)

controller.center
controller.instant!(:dimmer => 0)
