require 'thor'

module BallOfLight
  module CLI
    class Calibrate < Thor
      desc "points", "calibrate named points"
      def points

        controller.center!
        controller.strobe_open!
        controller.off!

        points = nil
        points = BallOfLightController.additional_points

        name = ask("What is the name of your point?")

        number = 0

        # MCY -- allow enter to automagically jump to the next light instead of typing n
        # and then 'n' inside aswd mode saves and jumps to the next light

        while(1) do
          answer = ask("Which light to calibrate? [1-12, (n)ext [#{number+1}] or (q)uit]")
          break if ["q", "quit"].include? answer

          if answer == "n"
            number += 1
          else
            number = answer.to_i
          end

          saved = BallOfLightController.additional_points

          points = {}
          # puts points.inspect
          points[number-1] ||= {}
          points[number-1][name] ||= {}

          controller.buffer(:dimmer => 0)
          controller.devices[number-1].buffer(:dimmer => 255)
          controller.write!

          say "Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC"

          pan  = saved[number-1][name.to_s]["pan"]  || 127
          tilt = saved[number-1][name.to_s]["tilt"] || 127
          puts pan
          puts tilt
          while(char = STDIN.getch)
            case char.downcase.ord
            when 97  # "a"
              pan = [pan+1, 0].max
            when 100 # "d"
              pan = [pan-1, 255].min
            when 119 # "w"
              tilt = [tilt+1, 255].min
            when 115 # "s"
              tilt = [tilt-1, 0].max
            when 27, 113
              break
            when 13, 32
              pt = {:pan => pan, :tilt => tilt}
              points[number-1][name] = pt
              say "saving light #{number} #{name} position #{pt.inspect}"
              BallOfLightController.write_points points
              break
            else
              puts char.ord
            end

            controller.devices[number-1].buffer(:pan => pan, :tilt => tilt)
            controller.write!
          end
        end
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

