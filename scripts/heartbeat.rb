#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require_relative '../lib/ball_of_light'

# This script is for:
# If no one is in the field

options = {}
if ENV['TEST']
  options.merge!(:cmd => "xargs -n1 echo")
#  options.merge!(:cmd => "xargs -n1 echo > /dev/null")
end

# setup controller
controller = BallOfLight::BallOfLightController.new(options)
i=0
while(1)
  begin
    # See if a 'Q' has been typed yet
    c = STDIN.read_nonblock(1)
    case c.downcase
    when "r"
      controller.buffer(:point => :red)
    when "g"
      controller.buffer(:point => :green)
    when "b"
      controller.buffer(:point => :blue)
    when "w"
      controller.buffer(:point => :white)
    when "q"
      break
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
end
