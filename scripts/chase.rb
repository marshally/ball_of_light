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
controller.bottom!
# sequence = [5, 10, 11, 7, 4, 1, 8, 12, 11, 6, 2, 5, 9, 12, 7, 3, 6, 10, 9, 8, 4, 1]

last = nil
count = controller.chase_sequence.count
[32.0, 24.0, 16.0, 12.0, 8.0, 6.0, 4.0, 2.0, 2.0, 2.0, 2.0].each do |duration|
  controller.chase_sequence.each do |light|
    # change colors here
    controller.buffer(:point => controller.random_color)
    # fade in to each other
    controller.buffer(:dimmer => 0)
    controller.begin_animation!(:seconds => duration/count/2) do
      last.dimmer(0) if last
      light.on
    end
    # light.on
    # controller.write!
    sleep (duration/count/2)
    last = light
  end
end

controller.strobe_open
controller.on!

controller.animate!(:seconds => 2) do |animate|
  animate.buffer(:dimmer => 1)
end
