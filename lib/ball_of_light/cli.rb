require 'thor'
require 'thor/group'
require 'io/console'

require File.expand_path(File.dirname(__FILE__) + "/cli/setup")
require File.expand_path(File.dirname(__FILE__) + "/cli/lights")
require File.expand_path(File.dirname(__FILE__) + "/cli/calibrate")
require File.expand_path(File.dirname(__FILE__) + "/cli/kinect")
require File.expand_path(File.dirname(__FILE__) + "/cli/upgrade")

module BallOfLight
  module CLI
    class App < Thor
      def initialize(*args)
        super(*args)

        ["ola_streaming_client", "kinectable_pipe"].each do |exe|
          running = `ps aux | grep #{exe} | grep -v grep`.strip
          if running != ""
            kill_it = ask "You seem to have an instance of #{exe} running. Do you want me to kill it? (Y/n)"
            unless kill_it.downcase[/\An/]
              pid = running.split(" ")[1]
              say " killing process:#{pid}, please restart"
              `kill -9 #{pid}`
              exit
            end
          end
        end
      end

      desc "versions", "switch to a specific version"
      def versions(tag=nil)
        tags = `git tag -l`.split

        unless tag
          say "Versions available:\n\t#{tags.join "\n\t"}"
        else
          if tags.include? tag
            result = `git checkout #{tag}`
          else
            say "Couldn't find tag #{tag}"
          end
        end
      end
    end
  end
end

BallOfLight::CLI::App.register(BallOfLight::CLI::Setup, "setup", "setup", "setup related commands")
BallOfLight::CLI::App.register(BallOfLight::CLI::Calibrate, "calibrate", "calibrate", "calibrate to environment")
BallOfLight::CLI::App.register(BallOfLight::CLI::Lights, "lights", "lights", "control lights")
BallOfLight::CLI::App.register(BallOfLight::CLI::Kinect, "kinect", "kinect", "control kinect")
BallOfLight::CLI::App.register(BallOfLight::CLI::Upgrade, "upgrade", "upgrade", "upgrade ball of light software")

