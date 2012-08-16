#!/usr/bin/env ruby
require 'bundler'

ENV['BUNDLE_GEMFILE'] ||= "#{File.dirname(File.realpath(__FILE__))}/../Gemfile"
Bundler.setup

require 'json'
require_relative '../lib/ball_of_light'
last = 0
output = {:gesture => {:skeleton_count => 0}}

$stdin.sync = true
$stdout.sync = true

while (line = $stdin.gets)
  $stdout.puts line
  begin
    if line.include? "skeletons"
      scene = Scene.new(:blob => line)
      scene.users.each do |user|
        if user.joints[:l_shoulder].vector && user.joints[:r_shoulder].vector
          v = (user.joints[:l_shoulder].vector - user.joints[:r_shoulder].vector).normalize
          output = {:gesture => {:userid => user.id, :facing => {:x => v[0], :y => v[1], :z => v[2]}}}
          $stdout.puts output.to_json
        end
      end
    end
  rescue JSON::ParserError
  end
end
