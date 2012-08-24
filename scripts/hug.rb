#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require_relative '../lib/ball_of_light'


options = {}
if ENV['TEST']
  options.merge!(:cmd => "xargs -n1 echo")
end

# setup controller
controller = BallOfLight::BallOfLightController.new(options)

#####################################################################
#
# THE HUG
#
#####################################################################
#
# Sequence of events
#
# 1. Kinect detects two people stepping into BoL.
# 2. All lights, except the 4 overhead lights, turn blue with a brightness
# level at around 50-60%.
# 3. The 4 overhead lights turn white at 50% brightness and they move to all
# toward the center.
# 4. The blue lights start to slowly fade as the two people start to move toward
# each other.  The idea is for the blue lights to be at their dimmest just before
# the two people make contact.
# 5. At the moment of contact, all lights flash from dimmest blue to full white
# at 100% brightness and quickly fade to about 80% for dramatic effect, and then
# all lights flash back to 100% brightness with strobe effect, cycling thru all
# colors to produce a chaotic colorful light show.  This could continue until the
# two people are no longer touching each other.

$stdout.puts "begin hug.rb"

controller.origin!

# All lights except 9, 10, 11, 12 turn blue
controller.top_lights.each do |light|
  light.blue
  light.dimmer(127)
end

# The overheads turn white, dim to 50%, and move to center
controller.top_lights.each do |light|
  light.nocolor
  light.dimmer(127)
  light.buffer(:point => :bottom)
end

$stdin.sync = true
$stdout.sync = true

start_time = Time.now
# Blue lights dim to very low light as both people approach
while(1)
  break if $stdin.closed?
  lines = IoHelper.readall_nonblocking($stdin)

  lines.reject!{|line| !line.include?("skeletons")}

  if line = lines.last
    begin
      scene = Scene.new(:blob => line)
      users = scene.users
      if scene.users.count > 1
        distance = (scene.users.first.joints[:head].vector - scene.users.last.joints[:head].vector).magnitude
        puts "hug distance: #{distance}"
        break if distance.magnitude < 100

        value = distance * 127 / 4000
        puts "hug value: #{value}"
        controller.top_lights.each do |light|
          light.buffer(:dimmer => value)
        end
        controller.animate!(:seconds => 0.1)
      end
    rescue JSON::ParserError
    end
  else
    sleep(0.1)
  end

  break if (Time.now - start_time) > 60
end

# at contact all lights go white

controller.nocolor
controller.dimmer!(255)

controller.animate!(:seconds => 1, :dimmer => 201)

controller.buffer(:dimmer => 255)
controller.strobe_fast

colors = [:yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings]

20.times do
  controller.devices.each do |light|
    # pick a random color for the light
    light.buffer :point => colors.shuffle.first
  end
  controller.write!
  sleep(0.250)
end






