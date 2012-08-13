require 'thor'
require 'thor/group'
require 'io/console'


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
require File.expand_path(File.dirname(__FILE__) + "/cli/setup")
require File.expand_path(File.dirname(__FILE__) + "/cli/lights")
require File.expand_path(File.dirname(__FILE__) + "/cli/calibrate")
require File.expand_path(File.dirname(__FILE__) + "/cli/kinect")

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

