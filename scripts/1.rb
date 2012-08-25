#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require_relative '../lib/ball_of_light'

# This script is for:
# If one person is in the field

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
  c.buffer(:dimmer => 255)
  c.white

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

def light_vectors
  @light_vectors = {
    0 => Vector[-1,0,-1].normalize,
    1 => Vector[1,0,-1].normalize,
    2 => Vector[1,0,1].normalize,
    3 => Vector[-1,0,1].normalize,

    4 => Vector[0,0,-1].normalize,
    5 => Vector[1,0,0].normalize,
    6 => Vector[0,0,1].normalize,
    7 => Vector[-1,0,0].normalize
  }
end

def pointing_at(v)
  dir = Vector[v["x"], v["y"], v["z"]].normalize

  differences = light_vectors.merge(light_vectors){|k,v|dir - v}
  closest = differences.keys.sort{|x,y| differences[x].magnitude <=> differences[y].magnitude}.first
end

start = Time.now
last_write = Time.now
$stdin.sync = true
while(1)

  # Using head or shoulder and hand, determine which general direction a person is
  # pointing. When pointing more toward one light than any other, change that light
  # to white and dim the other lights 50%. (still strobing or pulsing!)  If it is
  # one of the bottom lights, tilt it to 20 degrees below the center/base position
  # (20 degrees below center of sphere).

  IoHelper.readall_nonblocking($stdin).each do |line|
    begin
      if line.include? "skeletons"
        scene = Scene.new(:blob => line)

        lights_facing = []

        # which lights are being faced?
        scene.users.each do |user|
          user.gestures.each do |gesture|
            if gesture["gesture"] && gesture["gesture"]["facing"]
              lights_facing << pointing_at(gesture["gesture"]["facing"])
            end
          end
        end

        reset_colors(controller)
        lights_facing.flatten.each do |light_num|
          light = controller.devices[light_num]

          puts "FOUND LIGHT #{light_num}"

          controller.buffer(:dimmer => 127)
          light.white
          light.buffer(:dimmer => 255)
        end
        controller.write!
        last_write = Time.now

      end
    rescue JSON::ParserError
    end
  end

  # if (Time.now - last_point_time) > 2
  #   last_pointed_at = nil
  #   reset_colors(controller)
  # end

  controller.animate!(:seconds => 0.05, :dimmer => controller.heartbeat.next)
  break if (Time.now - last_write) > 15
  break if (Time.now - start) > 180
end

