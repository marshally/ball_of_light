## Calibration

```bash
ball_of_light calibrate
```

The Ball of Light supports two different calibration routines: Point Calibration
and Auto Calibration. Using Point Calibration, we can label

Recommended floor points to calibrate: front (closest to the Kinect), back
(farthest from the Kinect), left, right, and bottom (direct center of the
floor).

This will begin the `ball_of_light` test sequence. There are 9 or more calibration points per light, so this will take between 15m and 1h for 12 lights. Depending on how quickly you move.

```
→ ball_of_light calibrate points

What is the name of your point? back

Which light to calibrate? [1-12, (n)ext [1] or (q)uit]
calibrating light 1
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 1 back position {:pan=>181, :tilt=>28}

Which light to calibrate? [1-12, (n)ext [2] or (q)uit]
calibrating light 2
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 2 back position {:pan=>76, :tilt=>40}

Which light to calibrate? [1-12, (n)ext [3] or (q)uit]
calibrating light 3
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 3 back position {:pan=>3, :tilt=>187}

Which light to calibrate? [1-12, (n)ext [4] or (q)uit]
calibrating light 4
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 4 back position {:pan=>234, :tilt=>58}

Which light to calibrate? [1-12, (n)ext [5] or (q)uit]
calibrating light 5
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 5 back position {:pan=>125, :tilt=>82}

Which light to calibrate? [1-12, (n)ext [6] or (q)uit]
calibrating light 6
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 6 back position {:pan=>79, :tilt=>75}

Which light to calibrate? [1-12, (n)ext [7] or (q)uit]
calibrating light 7
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 7 back position {:pan=>116, :tilt=>10}

Which light to calibrate? [1-12, (n)ext [8] or (q)uit]
calibrating light 8
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 8 back position {:pan=>166, :tilt=>72}

Which light to calibrate? [1-12, (n)ext [9] or (q)uit]
calibrating light 9
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 9 back position {:pan=>127, :tilt=>103}

Which light to calibrate? [1-12, (n)ext [10] or (q)uit]
calibrating light 10
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 10 back position {:pan=>103, :tilt=>115}

Which light to calibrate? [1-12, (n)ext [11] or (q)uit]
calibrating light 11
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 11 back position {:pan=>93, :tilt=>47}

Which light to calibrate? [1-12, (n)ext [12] or (q)uit]
calibrating light 12
Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC
saving light 12 back position {:pan=>161, :tilt=>53}
```
