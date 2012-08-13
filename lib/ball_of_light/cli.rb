require 'thor'
require 'thor/group'
require 'io/console'

require File.expand_path(File.dirname(__FILE__) + "/setup")
require File.expand_path(File.dirname(__FILE__) + "/lights")
require File.expand_path(File.dirname(__FILE__) + "/calibrate")
require File.expand_path(File.dirname(__FILE__) + "/kinect")

["ola_streaming_client", "kinectable_pipe"].each do |exe|
  running = `ps aux | grep #{exe} | grep -v grep`.strip
  if running != ""
    puts "You seem to have an instance of #{exe} running. Do you want me to kill it? (Y/n)"
    unless STDIN.gets.downcase[/\An/]
      pid = running.split(" ")[1]
      `kill -9 #{pid}`
    end
  end
end

module BallOfLight
  module CLI
    class App < Thor
    end
  end
end

BallOfLight::CLI::App.register(BallOfLight::CLI::Setup, "setup", "setup", "setup related commands")
BallOfLight::CLI::App.register(BallOfLight::CLI::Calibrate, "calibrate", "calibrate", "calibrate to environment")
BallOfLight::CLI::App.register(BallOfLight::CLI::Lights, "lights", "lights", "control lights")
BallOfLight::CLI::App.register(BallOfLight::CLI::Kinect, "kinect", "kinect", "control kinect")
