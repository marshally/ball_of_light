require 'thor'
require 'open3'
module BallOfLight
  module CLI
    class Calibrate < Thor
      desc "points", "calibrate named points"
      def points

        controller.center!
        controller.strobe_open!
        controller.buffer(:dimmer => 0)

        points = nil
        points = BallOfLightController.additional_points

        name = ask("What is the name of your point?")

        number = 0

        while(1) do
          answer = ask("Which light to calibrate? [1-12, (n)ext [#{number+1}] or (q)uit]")
          break if ["q", "quit"].include? answer

          if answer == "n" || answer == ""
            number += 1
            exit if number > controller.devices.count
            say "calibrating light #{number}"
          else
            number = answer.to_i
          end

          points = BallOfLightController.additional_points

          # puts points.inspect
          points[number-1] ||= {}
          points[number-1][name] ||= {}

          controller.origin!
          controller.buffer(:dimmer => 0)
          controller.devices[number-1].buffer(:dimmer => 255)
          controller.write!

          say "Press (a/d) to pan and (w/s) to tilt. <space/enter> to save or (q)uit/ESC"

          pan  = points[number-1][name.to_s]["pan"]  || 127
          tilt = points[number-1][name.to_s]["tilt"] || 127
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
              say char.ord
            end

            controller.devices[number-1].buffer(:pan => pan, :tilt => tilt)
            controller.write!
          end
        end
      end

      desc "auto", "magic"
      def auto
        start = Time.now
        controller.instant!(:point => :bottom)
        cmd = "#{ENV['HOME']}/Projects/kinectable_pipe/kinectable_pipe -r 4"
        stdin, stdout, wait = Open3.popen2e(cmd)

        say "someone should stand in the frame until there is some output"
        capture_images(stdout, "#{ENV['HOME']}/.ball_of_light/person")

        yes? "is the person out of the frame? (yes)"

        controller.off!

        controller.devices.each do |device|
          controller.bottom!
          controller.dimmer!(0)
          device.dimmer(255)
          controller.write!
          pan0, tilt0 = device.current_values
          puts "bottom at pan:#{pan0}, tilt:#{tilt0}"
          next unless pan0
          next unless tilt0
          4.times do |p|
            [3, 0, -3].each do |i|
              pan  = pan0 + (p+1)*i
              4.times do |t|
                [1, -1].each do |j|
                  tilt = tilt0 + t*j
                  if pan >= 0 && pan <= 255 && tilt >= 0 && tilt <= 255
                    puts "pan:#{pan} tilt:#{tilt}"

                    device.buffer(:tilt => tilt, :pan => pan)
                    sleep(0.1)
                    controller.write!
                    capture_images(stdout, "#{ENV['HOME']}/.ball_of_light/light_#{1+(device.start_address-1)/5}_pan#{pan}_tilt#{tilt}")
                  end
                end
              end
            end
          end
        end

        say "#{Time.now - start} seconds elapsed"
      end

      no_tasks do
        def capture_images(pipe, name)
          say "capture_images(pipe, #{name}"
          line = ""
          until line.include?("images saved") && File.exists?("rgb.png") && File.exists?("depth.png")
            line = pipe.gets
            # puts line
          end
          ["rgb", "depth"].each do |img|
            fname = "#{name}_#{img}.png"
            if File.exists? fname
              File.delete fname
            end
            File.rename "./#{img}.png", fname
          end
        end

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

