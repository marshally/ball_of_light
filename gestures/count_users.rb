#!/usr/bin/env ruby
require 'json'

last = 0
output = {:gesture => {:skeleton_count => 0}}

STDOUT.sync = true
STDOUT.puts output.to_json

STDIN.each do |line|
  STDOUT.puts line
  begin
    blob = JSON.parse(line)
    if blob["skeletons"]
      if blob["skeletons"].count != last
        last = blob["skeletons"].count
        output = {:gesture => {:skeleton_count => last}}
        STDOUT.puts output.to_json
      end
    end
  rescue JSON::ParserError
  end
end
