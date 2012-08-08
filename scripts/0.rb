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

#####################################################################

# Send the exact same command to all lights for this series:`
# Point toward the center for 30 seconds.

# This command turns all of the lights in the controller on
controller.buffer(:dimmer => 255)
# This command centers the lights
controller.buffer(:pan => 127, :tilt => 127)
# This command also centers the lights, through use of a point named "center",
# which is set up so that :center => :pan => 127, :tilt => 127
controller.buffer(:point => :center)
# you can call named points as if they are methods. This buffers the command
controller.center
# write! sends whatever is in the buffer
controller.write!

controller.white! # this sends the named point instantly

# Cycle through each color with .5 sec/color.
[:yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings, :white].each do |color|
  controller.instant!(:point => color)
  sleep(0.5)
end

# Strobe for a second and point at the ground
controller.strobe_fast
controller.bottom!
sleep(1)

controller.strobe_open
# Have all lights sweep slowly back and forth for 30 sec, cycling through the
# colors. The lights have a greater range in one axis, so sweep in that
# direction. Return to center when complete.
3.times do
  # back 2.5 seconds
  controller.animate!(:seconds => 2.5, :pan => 0, :gobo => 8)
  # forward 5 seconds
  controller.animate!(:seconds => 5, :pan => 255, :gobo => 57)
  # and back to center
  controller.animate!(:seconds => 2.5, :point => :center)
end

# Have all lights inscribe a slow spiral, terminating in a circle, as wide as
# the hardware allows. Curved spirals are hard to program, so you can do an easy
# square spiral with a couple of do loops. Continue cycling between colors with
# each loop. (or substitute a cooler routine.)
controller.spiral_out

# Put all lights in automatic light routine for 30 seconds
# MCY: not sure what this means?

# Do the spiral in reverse.
controller.spiral_in
controller.animate!(:seconds => 2.5, :point => :front)
controller.animate!(:seconds => 2.5, :point => :left)
controller.animate!(:seconds => 2.5, :point => :back)
controller.animate!(:seconds => 2.5, :point => :bottom)


controller.center
controller.instant!(:dimmer => 0)
