
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
