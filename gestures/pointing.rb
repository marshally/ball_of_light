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
  wrote = false
  begin
    blob = JSON.parse(line)
    if blob["skeletons"]
      scene = Scene.new(blob)

      scene.users.each do |u|
        if v = u.pointing
          u.gestures << {:pointing => {:x => v[0], :y => v[1], :z => v[2]}}
        end
      end

      $stdout.puts scene.to_json
      wrote = true
    end
  rescue JSON::ParserError
  end

#  $stdout.puts line unless wrote

end
