require 'thor'
require 'io/console'

require_relative "ball_of_light_controller"

# Hey you: reader of this code!
# This is a hacktastic mess.
module BallOfLight
  class CLI < Thor
    include Thor::Actions

    desc "test", "runs tests (specify with --only kinect dmx ola)"
    method_option :only, :aliases => "--only", :desc => "component to test, e.g. -s kinect dmx ola"
    def test
      case options[:only]
      when "kinect"
        test_kinect
      when "dmx"
        test_usbpro
      when "ola"
        test_ola
      when nil
        test_kinect
        test_usbpro
        test_ola
      else
        say "Invalid --only. Values"
      end
    end

    desc "configure", "configures subsystems"
    method_option :flexible, :type => :boolean, :defaults => false, :desc => "Use flexible OLA configuration file (default: false)", :banner => "false"
    method_option :disable_unused_devices, :type => :boolean, :defaults => true, :desc => "Disables all OLA devices except DMX USB Pro (default: true)", :banner => true
    def configure
      if options[:flexible]
        config_ola_flexible
      else
        config_ola_fixed
      end

      if options[:disable_unused_devices]
        disable_unused_ola_devices
      end
    end

    desc "lights", "control DMX lights"
    method_option :list, :type => :boolean, :defaults => true
    method_option :center, :type => :boolean, :defaults => true
    method_option :testing, :type => :boolean, :defaults => true
    def lights
      list_lights if options[:list]
      center if options[:center]
    end

    desc "calibrate", "calibrate named points"
    def calibrate

      controller.center!
      controller.strobe_open!
      controller.off!

      points = nil
      points = BallOfLightController.additional_points

      name = ask("What is the name of your point?")

      while(1) do
        answer = ask("Which light to calibrate? [1-12, or (q)uit]")
        break if ["q", "quit"].include? answer

        number = answer.to_i
        points[number-1] ||= {}
        points[number-1][name] = {}

        controller.set(:dimmer => 0)
        controller.devices[number-1].set(:dimmer => 255)
        controller.write!

        say "Press (a/d) to pan and (w/s) to tilt. <space> to save or (q)uit"

        pan, tilt = 127, 127

        while(char = STDIN.getch)
          case char.downcase
          when "a"
            pan = [pan-1, 0].max
          when "d"
            pan = [pan+1, 255].min
          when "w"
            tilt = [tilt+1, 255].min
          when "s"
            tilt = [tilt-1, 0].max
          when "q"
            break
          when " "
            points[number-1][name] = {:pan => pan, :tilt => tilt}
            BallOfLightController.write_points points
            break
          else
          end

          controller.devices[number-1].set(:pan => pan, :tilt => tilt)
          controller.write!
        end
      end
    end

    no_tasks do
      def usb_devices
        @usb_devices ||= Dir["/dev/cu.usb*"]
      end

      def test_kinect
        say "Testing the MS Kinect"
        cmd = "kinectable_pipe"
        unless `which #{cmd}`.include? cmd
          say "ERROR: It looks like #{cmd} has not been installed (or is not on your PATH). Try:"
          say "\n  brew install #{cmd}"
        else
          # HACK
          pipe = IO.popen(cmd, "r")
          unless pipe.gets.include? "initializing"
            say "unknown error with kinect"
          end
          if pipe.gets.include? "problem initializing kinect"
            say "ERROR: problem initializing kinect. Is it plugged in?"
          end
          pipe.close
        end
      end

      def test_usbpro
        say "Testing the DMX USB Pro"
        case usb_devices.count
        when 0
          say "I can't find your DMX USB Pro. Have you installed the drivers from:"
          say "  http://www.ftdichip.com/Drivers/VCP.htm"
        when 1
        else
          say "I found more than one DMX USB Pro device. I'm not sure what to do from here?"
        end
      end

      def test_ola
        say "Testing OLA"
        raise NotImplementedError
      end

      def ola_dir
         ENV['HOME'] + "/.ola"
      end

      def config_ola_flexible
        flexible = "
    device_dir = /dev
    device_prefix = ttyUSB
    device_prefix = cu.usbserial-"
        empty_directory ola_dir
        create_file "#{ola_dir}/ola-usbpro.conf", flexible
      end

      def config_ola_fixed
        if usb_devices.count < 1
          raise NotImplementedError.new "Could not find DXM USB Pro"
        elsif usb_devices.count > 1
          raise NotImplementedError.new "Found too many USB devices, not sure what to do?"
        else
          fixed = "device = #{usb_devices.first}"
          empty_directory ola_dir
          create_file "#{ola_dir}/ola-usbpro.conf", fixed
        end
      end

      def disable_unused_ola_devices
        confs = ['artnet', 'e131', 'opendmx', 'shownet', 'dummy', 'espnet', 'pathport',
          'sandnet', 'stageprofi', 'usbdmx', 'usbserial']

        confs.each do |conf|
          file = "~/.ola/ola-#{conf}.conf"
          unless `cat #{file}`.include? "enabled"
            say "disabling #{file}"
            append_file file, 'enabled = false'
          end
        end
      end

      def center
        controller.instant!(:point => :center)
        controller.strobe_open!
        controller.dimmer!(255)
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
