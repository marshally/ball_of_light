#!/usr/bin/env ruby
require 'open3'
STDOUT.sync = true

["ola_streaming_client", "kinectable_pipe"].each do |exe|
  running = `ps aux | grep #{exe} | grep -v grep`.strip
  if running != ""
    puts "kinectable_pipe is already running. You can kill it with:"
    pid = running.split(" ")[1]
    puts "kill -9 #{pid}"
    exit
  end
end

basedir= File.dirname(File.realpath(__FILE__)) + "/../"
gestures = Dir.glob("#{basedir}gestures/*.rb")

cmd = ENV["KINECT_CMD"] || "kinectable_pipe"
gestures.unshift cmd

nothing, $input = Open3.popen2e(gestures.join " | ")
# read_pipe, thread_wait = Open3.op(cmd, "ruby #{basedir}gestures/count_users.rb", "ruby #{basedir}gestures/pointing.rb")
$input.sync = true

while line = $input.gets
  # if (!ENV["TEST"]==1) || (line.include?("gesture"))
    STDOUT.puts line
  # end
end
