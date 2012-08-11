require 'thor'
require File.expand_path(File.dirname(__FILE__) + "/../ball_of_light_controller")

module BallOfLight
  module CLI
    class Lights < Thor
      desc "center", "center lights"
      def center
        controller.instant!(:point => :center)
        controller.strobe_open!
        controller.dimmer!(255)
        controller.top_lights.each do |light|
          light.buffer(:point => :white)
        end
        controller.write!
      end

      desc "heartbeat", "heartbeat"
      def heartbeat
        controller.instant!(:point => :center)
        controller.strobe_open!
        controller.dimmer!(255)
        100.times do
          controller.heartbeat!
        end
      end

      desc "capabilities", "display the lights basic capabilities"
      def capabilities
        say controller.capabilities
      end

      desc "points", "display the named points"
      def points
        say controller.points
      end

      no_tasks do
        def list_lights
          say controller.devices.map{|d| d.start_address }.inspect
        end

        def controller
          params = {}
          if options[:testing]
            params.merge!(:cmd => "xargs -n1 echo")
          end
          @controller ||= BallOfLight::BallOfLightController.new params
        end
      end
    end
  end
end
