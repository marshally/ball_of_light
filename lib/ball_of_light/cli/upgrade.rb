require 'thor'
require File.expand_path(File.dirname(__FILE__) + "/../ball_of_light_controller")

module BallOfLight
  module CLI
    class Upgrade < Thor
      include Thor::Actions
      default_task :all

      desc "fetch", "download latest code (but don't install)"
      def fetch
        FileUtils.cd File.dirname(__FILE__) do
          run "git fetch origin"
        end
      end

      desc "all", "get the latest code"
      method_option :force, :type => :boolean, :defaults => false #, :desc => "Use flexible OLA configuration file (default: false)", :banner => "false"
      def all
        fetch

        ahead_origin = `git log origin/master...HEAD --right-only 2> /dev/null | grep '^commit'`.strip
        behind_origin = `git log origin/master...HEAD --left-only 2> /dev/null | grep '^commit'`.strip

        if behind_origin != ""
          say "You have unpushed changes in your local tree. Cannot automatically upgrade."
        elsif options[:force] || ahead_origin != ""
          say "You are missing some upstream changes."
          unless no? "Would you like to upgrade? (Y/n)" || options[:force]
            run "git pull origin master"
          end
        end
      end
    end
  end
end
