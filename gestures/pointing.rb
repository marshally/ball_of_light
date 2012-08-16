#!/usr/bin/env ruby
require 'bundler'
ENV['BUNDLE_GEMFILE'] ||= "#{File.dirname(File.realpath(__FILE__))}/../Gemfile"
Bundler.setup

require 'json'
require 'matrix'

require_relative "../lib/ball_of_light"

$stdout.sync = true
$stdin.sync = true

last = 0

$stdin.each do |line|
  $stdout.puts line
  begin
    blob = JSON.parse(line)
    if blob["skeletons"]
      Scene.new(blob).users.each do |u|
        if v = u.pointing
          output = {:gesture => {:userid => u.id, :point => {:x => v[0], :y => v[1], :z => v[2]}}}
          $stdout.puts output.to_json
        end
      end
    end
  rescue JSON::ParserError
  end
end
