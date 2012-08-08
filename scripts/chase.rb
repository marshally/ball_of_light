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

# sequence = [5, 10, 11, 7, 4, 1, 8, 12, 11, 6, 2, 5, 9, 12, 7, 3, 6, 10, 9, 8, 4, 1]

count = controller.chase_sequence.count
[8.0, 6.0, 4.0, 2.0, 1.0, 1.0, 1.0, 1.0].each do |duration|
  [0,1,2,3,8].map{|d| controller.devices[d]}.each do |light|
#  controller.chase_sequence.each do |light|
    controller.buffer(:dimmer => 0)
    light.on
    light.strobe_fast
    controller.write!
    sleep (duration/count)
  end
end

controller.strobe_open
controller.on!

controller.animate!(:seconds => 2) do |animate|
  animate.buffer(:dimmer => 0)
end
