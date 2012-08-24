#!/usr/bin/env ruby
require 'bundler'

ENV['BUNDLE_GEMFILE'] ||= "#{File.dirname(File.realpath(__FILE__))}/../Gemfile"
Bundler.setup

require 'json'
require_relative '../lib/ball_of_light'
last = 0

$stdin.sync = true
$stdout.sync = true

while (line = $stdin.gets)
  wrote = false
  begin
    if line.include? "skeletons"
      scene = Scene.new(:blob => line)
      scene.users.each do |user|
        if v = user.facing
          user.gestures << {:gesture => {:userid => user.id, :facing => {:x => v[0], :y => v[1], :z => v[2]}}}
        end
      end
      $stdout.puts scene.to_json
      wrote = true
    end
  rescue JSON::ParserError
  end

  $stdout.puts line unless wrote
end
