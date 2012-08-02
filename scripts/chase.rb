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


controller.off!

# ring_one   = [5, 10, 11, 7, 4, 1] # yellow
# ring_two   = [8, 12, 11, 6, 2, 1] # blue
# ring_three = [2, 5, 9, 12, 7, 3] # red
# ring_four  = [3, 4, 8, 9, 10, 6] # green

sequence = [5, 10, 11, 7, 4, 1, 8, 12, 11, 6, 2, 5, 9, 12, 7, 3, 6, 10, 9, 8, 4, 1]

[8.0, 6.0, 4.0, 2.0, 1.0, 1.0, 1.0, 1.0].each do |duration|
  puts duration
  sequence.each do |light|
    controller.buffer(:dimmer => 0)
    controller.devices[light-1].on
    controller.devices[light-1].strobe_fast
    controller.write!
    sleep (duration/sequence.count)
  end
end

controller.strobe_open
controller.on!

puts "end"
controller.begin_animation!(:seconds => 2) do |devices|
  devices.each {|d| d.buffer(:dimmer => 0)}
end
