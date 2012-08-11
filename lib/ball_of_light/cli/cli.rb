require 'thor'
require 'thor/group'
require 'io/console'

require File.expand_path(File.dirname(__FILE__) + "/setup")
require File.expand_path(File.dirname(__FILE__) + "/lights")
require File.expand_path(File.dirname(__FILE__) + "/calibrate")

# Hey you: reader of this code!
# This is a hacktastic mess.
module BallOfLight
  module CLI
    class App < Thor
    end
  end
end

BallOfLight::CLI::App.register(BallOfLight::CLI::Setup, "setup", "setup", "setup related commands")
BallOfLight::CLI::App.register(BallOfLight::CLI::Calibrate, "calibrate", "calibrate", "calibrate to environment")
BallOfLight::CLI::App.register(BallOfLight::CLI::Setup, "lights", "lights", "control lights")

