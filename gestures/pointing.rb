#!/usr/bin/env ruby
require 'bundler'
Bundler.setup


require 'json'
require 'matrix'

require_relative "../lib/ball_of_light"

STDOUT.sync = true

last = 0

STDIN.each do |line|
  STDOUT.puts line
  begin
    blob = JSON.parse(line)
    if blob["skeletons"]
      Scene.new(blob).users.each do |u|
        if v = u.pointing
          output = {:gesture => {:point => {:x => v[0], :y => v[1], :z => v[2]}}}
          STDOUT.puts output.to_json
        end
      end
    end
  rescue JSON::ParserError
  end
end
