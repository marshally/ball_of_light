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
controller.on!

$stdin.sync = true
$stdout.sync = true

puts "lets get em"

last_beat = Time.now - 10
points = [:bottom, :center, :left, :right, :front, :back]
pans = [0,255]
while(1)

  # Using head or shoulder and hand, determine which general direction a person is
  # pointing. When pointing more toward one light than any other, change that light
  # to white and dim the other lights 50%. (still strobing or pulsing!)  If it is
  # one of the bottom lights, tilt it to 20 degrees below the center/base position
  # (20 degrees below center of sphere).
  time_since_last_beat = Time.now - last_beat
  if (got_a_beat = IoHelper.gets_most_recent($stdin))
    puts "got a beat"
    last_beat = Time.now
    # everyone gets the same random color
    controller.buffer(:point => controller.random_color)
    # everyone gets a different random point
    controller.devices.each do |device|
      device.buffer(:point => points.sample)
    end
    controller.write!
    $stdout.puts "read! #{got_a_beat}"
  elsif time_since_last_beat > 5
    $stdout.puts "no beat, lets shuffle #{pans.last}"
    # let's spend 10.5 seconds doing the factory routine
    controller.buffer(:point => controller.random_color)
    controller.animate!(:seconds => 0.5, :tilt => rand(255).to_i)
    controller.buffer(:point => controller.random_color)
    controller.animate!(:seconds => 1, :pan => pans.rotate!.first)
  else
    sleep(0.05)
  end

  # check the input pipe for kill condition?
end



puts "dying"
