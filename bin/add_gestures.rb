#!/usr/bin/env ruby
require 'open3'
STDOUT.sync

cmd = ENV["KINECT_CMD"] || "kinectable_pipe"

gestures = Dir.glob("gestures/*.rb")
gestures.unshift cmd
read_pipe, thread_wait = Open3.pipeline_r(cmd, "ruby gestures/count_users.rb", "ruby gestures/pointing.rb")

while line = read_pipe.gets
  if (!ENV["TEST"]==1) || (line.include?("gesture"))
    puts line
  end
end
