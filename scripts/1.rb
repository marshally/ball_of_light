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

def reset_colors(c)
  # Bottom lights point straight up and turn blue. This should be about 45 degrees.
  # (This acknowledges the person and points the lights away from the person’s eyes.)
  c.bottom_lights.each do |light|
#    light.up
    light.blue
  end

  # Top and equator lights turn red
  # Top lights tilt down toward base. This should be about 15 degrees.
  c.top_lights.each do |light|
    light.red
#    light.bottom
  end

  # Equatorial lights tilt down toward base. This should be about 45 degrees.
  c.middle_lights.each do |light|
    light.yellow
#    light.bottom
  end
end

def pointing_at(json)
    # We can determine which light they are
    # pointing at by plotting the coordinates of lights into the Kinect’s space and
    # then measuring the slope of the hand/elbow or hand/shoulder. The XYZ coordinates
    # of the lights should be constants. (Note that although the top lights are
    # directly above the bottom lights, the equatorial lights are between two
    # bottoms and two tops.
    return nil
end

#####################################################################

# Return all lights to center for 1 second with round white spot.
controller.begin_animation!(:seconds => 2.5, :point => :center)
sleep(1)

controller.write!

# Begin pulsing all lights not being pointed at in a heartbeat rhythm. You may be
# able to use the strobe feature to save programming.
controller.heartbeat!

# Begin Kinect body detection routine
reset_colors(controller)

start = Time.now

while(1)
  begin
    # Using head or shoulder and hand, determine which general direction a person is
    # pointing. When pointing more toward one light than any other, change that light
    # to white and dim the other lights 50%. (still strobing or pulsing!)  If it is
    # one of the bottom lights, tilt it to 20 degrees below the center/base position
    # (20 degrees below center of sphere).

    json = STDIN.read_nonblock(10000)
    reset_colors(controller)
    controller.buffer(:dimmer => 127)
    if light = controller.devices[json.to_i] # pointing_at(json)
      puts "FOUND LIGHT #{light.start_address}"
      light.white
      light.buffer(:dimmer => 255)
      controller.write!
    end

    false
  rescue Errno::EINTR
    puts "Well, your device seems a little slow..."
    false
  rescue Errno::EAGAIN
    # nothing was ready to be read
    false
  rescue EOFError
    # quit on the end of the input stream
    # (user hit CTRL-D)
    puts "Who hit CTRL-D, really?"
    true
  rescue Exception
    puts Exception
  end
  controller.begin_animation!(:seconds => 0.05, :dimmer => controller.heartbeat.next)
  break if (Time.now - start) > 30
end

