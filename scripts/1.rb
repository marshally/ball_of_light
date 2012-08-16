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

puts "1 players"
# setup controller
controller = BallOfLight::BallOfLightController.new(options)

$stdout.sync = true
#####################################################################

def reset_colors(c)
  # Bottom lights point straight up and turn blue. This should be about 45 degrees.
  # (This acknowledges the person and points the lights away from the person’s eyes.)
  c.bottom_lights.each do |light|
    light.buffer(:point => :top)
    light.blue
  end

  # Top and equator lights turn red
  # Top lights tilt down toward base. This should be about 15 degrees.
  c.top_lights.each do |light|
    light.red
    light.buffer(:point => :bottom)
  end

  # Equatorial lights tilt down toward base. This should be about 45 degrees.
  c.middle_lights.each do |light|
    light.yellow
    light.buffer(:point => :bottom)
  end
end

#####################################################################

# Return all lights to center for 1 second with round white spot.
controller.animate!(:seconds => 2.5, :point => :center)
sleep(1)

controller.write!

# Begin pulsing all lights not being pointed at in a heartbeat rhythm. You may be
# able to use the strobe feature to save programming.
controller.heartbeat!

# Begin Kinect body detection routine
reset_colors(controller)

def pointing_at(v, c)
  if v["x"] < 0
    c.right_lights
  else
    c.left_lights
  end
end

start = Time.now
last_point_time = Time.now
last_pointed_at = nil
$stdin.sync = true
while(1)

  # Using head or shoulder and hand, determine which general direction a person is
  # pointing. When pointing more toward one light than any other, change that light
  # to white and dim the other lights 50%. (still strobing or pulsing!)  If it is
  # one of the bottom lights, tilt it to 20 degrees below the center/base position
  # (20 degrees below center of sphere).

  IoHelper.readall_nonblocking($stdin).each do |line|
    begin
      blob = JSON.parse(line)
      if blob["gesture"]
        if blob["gesture"]["facing"]
          puts line
          # {"gesture":{"userid":0,"facing":{"x":-0.6985372894594434,"y":-0.6771431426207392,"z":-0.2313499938110291}}}

          direction = blob["gesture"]["facing"]
          pointing_at(direction, controller).each do |light|
            puts "FOUND LIGHT #{light}"

            controller.buffer(:dimmer => 127)
            light.white
            light.buffer(:dimmer => 255)
            controller.write!
          end
        end
      end
    rescue JSON::ParserError
    end
  end

  # if (Time.now - last_point_time) > 2
  #   last_pointed_at = nil
  #   reset_colors(controller)
  # end

  controller.animate!(:seconds => 0.05, :dimmer => controller.heartbeat.next)
  break if (Time.now - start) > 180
end

