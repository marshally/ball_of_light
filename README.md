# ball_of_light

[![Build Status](https://secure.travis-ci.org/marshally/ball_of_light.png?branch=master)](http://travis-ci.org/marshally/ball_of_light)

1. [Project Goals](#project-goals)
2. [Example](#example)
3. [Capabilities](https://github.com/marshally/ball_of_light/blob/master/Capabilities.md)
4. [Installation](https://github.com/marshally/ball_of_light/blob/master/Installation.md)
5. [Calibration](https://github.com/marshally/ball_of_light/blob/master/Calibration.md)
6. [On-site Setup](https://github.com/marshally/ball_of_light/wiki/On-site-Setup)

## Project Goals

Create an light show based on the movements of participants, with data gathered by a Microsoft Kinect. See [the Ball of Light](http://balloflight.com)

## Example

Yeah, yeah. Just show me the code.

Here's a simple script that connects to the DMX controller, centers and turns on
the lights, and then cycles through the colors every 5 seconds.

```ruby
#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

# setup controller
controller = BallOfLight::BallOfLightController.new(options)

# Section Goal: Point toward the center for 30 seconds.





# This command turns the all of the lights on
controller.on!

# alternatively, you could turn the lights on "the hard way" by sending
# queueing up the command buffer with a 0-255 integer to the dimmer
# control. And then using the write! method to flush the buffer.
#
#      controller.buffer(:dimmer => 255)
#      controller.write!
#

# methods called without the exclamation point only write to the buffer.
# with the exclamation point, your commands will get sent to the DMX
# controller immediately.

# Now let's turn all of the lights to the center point.
controller.center

# Hmmm. We're not sure what color wheel location someone previously left
# on the lights, so let's be careful and switch it back to white.
controller.nocolor # this sends the named point instantly
controller.write! # this sends whatever is in the buffer

# Now the fun part. Let's set up a little loop and run through all the
# colors with a half second delay in between.

[:yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings].each do |color|
  controller.instant!(:point => color)
  sleep(0.5)
end

# what else can it do?
# show me a list all of the capabilities of the hooked up devices
puts controller.capabilities
# => [:pan, :tilt, :strobe, :gobo, :dimmer]
# these are the basic commands that we can send to the DmxController or the
# DmxDevices it holds

# show me a list all of the named points of the hooked up devices
puts controller.points
# => [:center, :strobe_blackout, :strobe_open, :strobe_slow, :strobe_fast, :strobe_slow_fast, :strobe_fast_slow, :strobe_random, :nocolor, :yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings, :on, :off]
# "points" are like little macros that are composed of one or more of the
# basic capabilities.

# For example, :center is the same as {:pan => 127, :tilt => 127}
```



