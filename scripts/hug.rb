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

#####################################################################
#
# THE HUG
#
#####################################################################
#
# Sequence of events
#
# 1. Kinect detects two people stepping into BoL.
# 2. All lights, except the 4 overhead lights, turn blue with a brightness
# level at around 50-60%.
# 3. The 4 overhead lights turn white at 50% brightness and they move to all
# toward the center.
# 4. The blue lights start to slowly fade as the two people start to move toward
# each other.  The idea is for the blue lights to be at their dimmest just before
# the two people make contact.
# 5. At the moment of contact, all lights flash from dimmest blue to full white
# at 100% brightness and quickly fade to about 80% for dramatic effect, and then
# all lights flash back to 100% brightness with strobe effect, cycling thru all
# colors to produce a chaotic colorful light show.  This could continue until the
# two people are no longer touching each other.


controller.origin!

overhead_ligts = [9,10,11,12]
lower_lights = [1,2,3,4,5,6,7,8]
# All lights except 9, 10, 11, 12 turn blue
lower_lights.each do |light|
  controller.devices[light-1].blue
  controller.devices[light-1].dimmer(127)
end

# The overheads turn white, dim to 50%, and move to center
overhead.each do |light|
  controller.devices[light-1].nocolor
  controller.devices[light-1].dimmer(127)
  controller.devices[light-1].set(:point => :bottom)
end

# Blue lights dim to very low light as both people approach

while (distance = STDIN.gets)
  # 4000 ~= 127
  #    0 = 0
  value = somefunction(distance)
  [1,2,3,4,5,6,7,8].each do |light|
    controller.devices[light].dimmer!(value)
  end

  break if value < 100
end

# at contact all lights go white

controller.nocolor
controller.dimmer!(255)

controller.begin_animation!(:seconds => 1) do |devices|
  # MCY: this is not exactly correct
  controller.devices.dimmer(201)
end

controller.dimmer(255)
controller.strobe_fast

colors = [:yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings]

20.times do
  [1,2,3,4,5,6,7,8,9,10,11,12].each do |light|
    # pick a random color for the light
    controller[light] = colors.shuffle.first
  end
  controller.write!
  sleep(0.250)
end





