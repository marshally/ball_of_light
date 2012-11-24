#!/usr/bin/env ruby
require 'open3'
require_relative "../lib/ball_of_light/io_helper"

BASEDIR = File.dirname(File.realpath(__FILE__)) + "/"

# kill existing processing tasks
# ps aux | grep Ruby-Processing

["'scripts/sound.rb'", "Ruby-Processing"].each do |exe|
  running = `ps aux | grep #{exe} | grep -v grep`.strip
  if running && pid = running.split(" ")[1]
    puts " killing process:#{exe}(#{pid}), please restart"
    `kill -9 #{pid}`
    exit
  end
end

last = 0

cmd = "ruby scripts/sound.rb 2>stderr.log >stdout.log"
lights, stdout, lights_thread = Open3.popen2e(cmd)

#cmd = "sox -q -e floating-point -b 32 -t coreaudio default -e signed-integer -b 16 -t wav - | aubioonset --threshold=0.9 -i -"
cmd = "bash -lc 'cd #{BASEDIR}; RBENV_VERSION=jruby-1.6.7.2 rp5 run extract_beats.rb'"
stdin, beats, beat_thread = Open3.popen2e(cmd)


last_beat = Time.now
while(beat_thread.alive? && beat = beats.gets)
  puts Time.now
  puts last_beat
  # don't double count the backbeat
  if Time.now - last_beat > 0.15
    puts beat
    lights.puts beat
  end
end
