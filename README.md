# ball_of_light

[![Build Status](https://secure.travis-ci.org/marshally/ball_of_light.png?branch=master)](http://travis-ci.org/marshally/ball_of_light)

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

## Capabilities

The Ball Of Light project is using 12 [Comscan LED](http://www.samash.com/wcsstore/root/Product_Manuals_Brochures/American%20DJ/ACOMSCANL/comscan_led.pdf) scanner lights.

### Natively the Comscan LEDs support:

* :pan (0-255) - a pan servo that turns the light clockwise/counter-clockwise
* :tilt (0-255) - a tilt mirror that sweeps the light up/down
* :strobe (0-255) - a strobe light
* :gobo (0-255) - a GOBO wheel that changes the colors of the lights
* :dimmer (0-255) - controls light brightness

### Additional capabilities from `open_lighting`

* :center
* :origin
* :strobe_blackout
* :strobe_open
* :strobe_slow
* :strobe_fast
* :strobe_slow_fast
* :strobe_fast_slow
* :strobe_random
* :nocolor
* :yellow
* :red
* :green
* :blue
* :teardrop
* :polka
* :teal
* :rings
* :on
* :off
* :bottom

See [open_lighting_rb](https://github.com/marshally/open_lighting_rb/blob/master/lib/open_lighting/devices/comscan_led.rb) for more information on how this works.

## Installation

### Hardware required

1. DMX USB Pro
1. Mac running OSX (Lion preferred)
    * homebrew package manager
        * [install instructions here](https://github.com/mxcl/homebrew/wiki/installation)
    * DMX USB Pro drivers install
1. Cables
    * USB 1.0 cable
    * 1x XLR 5-pin to XLR 3 pin
    * 11x XLR 3-pin male to XLR 3-pin female

### Software Installation

1. Install Homebrew packages

    ````
    brew tap marshally/homebrew-alt
    brew install ball_of_light
    ````

2. Install DMX USB Pro drivers from [http://www.ftdichip.com/Drivers/VCP.htm](http://www.ftdichip.com/Drivers/VCP.htm)


### Hardware Installation

1. plug in MS Kinect
    * check that Kinect is operational
    * `ball_of_light test --only kinect`
1. plug in DMX USB Pro
    1. check that the DMX USB Pro is operational
        * `ball_of_light test --only dmx`
    1. configure DMX ports
        * `ball_of_light configure`
    1. check that the Open Lighting Architecture system is operational
        * `ball_of_light test --only ola`
1. Daisy chain connect all of the lights together
1. Set each light to a unique DMX control number, offset by 5
    * e.g. 1,6,11,16,21,26,31,36,41,46,51,56
    * `ball_of_light lights --list`
1. check that lights are operational with
    * `ball_of_light lights --center`
1. what to see the raw commands that the lights are executing? pass in --testing
    * `ball_of_light lights --center --testing`

### Calibration

````
ball_of_light calibrate
````

This will begin the `ball_of_light` test sequence. There are 9 or more calibration points per light, so this will take between 15m and 1h for 12 lights. Depending on how quickly you move.
