ball_of_light
=============

[![Build Status](https://secure.travis-ci.org/marshally/ball_of_light.png?branch=master)](http://travis-ci.org/marshally/ball_of_light)

Goals
-----

Create an light show based on the movements of participants, with data gathered by a Microsoft Kinect.

Hardware required
-----------------
1. DMX USB Pro
1. Mac running OSX (Lion preferred)
  1. homebrew package manager
  1. DMX USB Pro drivers install
1. Cables
  1. USB 1.0 cable
  1. 1x XLR 5-pin to XLR 3 pin
  2. 11x XLR 3-pin male to XLR 3-pin female

Software Installation
---------------------
````
brew tap marshally/homebrew-alt
brew install ball_of_light
````

Hardware Installation
---------------------
1. plug in MS Kinect
  * check that Kinect is operational
  * `ball_of_light kinect:test`
1. plug in DMX USB Pro
  1. configure DMX port
    * `ball_of_light configure:ports`
1. Daisy chain connect all of the lights together
1. Set each light to a unique DMX control number, offset by 5
  * e.g. 1,6,11,16,21,26,31,36,41,46,51,56
  * `ball_of_light lights:list`
1. check that lights are operational with
  * `ball_of_light lights:test`


Calibration
-----------

````
ball_of_light calibrate
````

This will begin the `ball_of_light` test sequence. There are 9 or more calibration points per light, so this will take between 15m and 1h for 12 lights. Depending on how quickly you move :)

Procedure

````
> ball_of_light calibrate
Acquiring user...
Found!
Would you like to calibrate a (S)ingle light or (A)ll lights?
How many lights are you calibrating? press <Enter> for 12, or enter a number
Calibrating Light #1
(all other lights have been turned off)
Tracking ...
L1/Position #1: Press <Enter> when the subject is standing in the middle of the light, or <ESC> if this point is not reachable.
L1/Position #1: Captured!
Adjusting light ...
L1/Position #2: Press <Enter> when the subject is standing in the middle of the light, or <ESC> if this point is not reachable.
L1/Position #2: Captured!
...
Captured light positions are saved in `~/.ball_of_light/calibration/1.json`
````

(until points for all twelve lights have been captured)

foreach (light in lights)
{
  lights.all
  while (needsPosition)
  {
    [0, 127, 255].each do |tilt|
      [0, 127, 255].each do |pan|
        light.send(:tilt => tilt, :pan => :pan)
        capture
      end
    end
    tilt = 127
    [63, 191].each do |pan|
      light.send(:tilt => tilt, :pan => :pan)
      capture
    end
  }
}
