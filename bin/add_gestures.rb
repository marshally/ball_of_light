#!/usr/bin/env ruby
require 'open3'

cmd = ENV["KINECT_CMD"] || "kinectable_pipe"

gestures = Dir.glob("gestures/*.rb")
gestures.unshift cmd
puts gestures.inspect
read_pipe, thread_wait = Open3.pipeline_r(cmd, "ruby gestures/count_users.rb", "ruby gestures/pointing.rb")

while line = read_pipe.gets
  puts line if line.include? "gesture"
end
