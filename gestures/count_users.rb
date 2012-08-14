#!/usr/bin/env ruby
require 'json'
require_relative '../lib/ball_of_light/io_helper'
last = 0
output = {:gesture => {:skeleton_count => 0}}

$stdin.sync = true
$stdout.sync = true

while (line = $stdin.gets)
  $stdout.puts line
  begin
    blob = JSON.parse(line)
    if blob["skeletons"]
      if blob["skeletons"].count != last
        last = blob["skeletons"].count
        output = {:gesture => {:skeleton_count => last}}
        $stdout.puts output.to_json
      end
    end
  rescue JSON::ParserError
  end
end
