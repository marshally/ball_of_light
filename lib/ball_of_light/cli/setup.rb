require 'thor'

module BallOfLight
  module CLI
    class Setup < Thor
      include Thor::Actions

      desc "dependencies", "checks to see if correct dependencies are installed"
      method_option :install, :aliases => "-i", :desc => "install missing dependencies"
      def dependencies
        brews = %w(rbenv ruby-build kinectable_pipe aubio open-lighting)

        installed = `brew list`
        not_installed = []
        brews.each do |brew|
          unless installed.include? brew
            not_installed << brew
            say "#{brew} is not installed"
          end
        end

        if options[:install]
          not_installed.each {|b| run "brew install #{b}"}
        end
      end

      desc "link", "symlinks executeable to /usr/local/bin"
      def link
        # TODO: find out why remove_file doesn't work here. grrrrr
        # remove_file "/usr/local/bin/ball_of_light"
        link = "/usr/local/bin/ball_of_light"
        if File.exists?(link)
          File.delete link
        end
        chmod "#{Dir.pwd}/bin/ball_of_light", 0777
        create_link "/usr/local/bin/ball_of_light", "#{Dir.pwd}/bin/ball_of_light", :force => true
      end

      desc "tunnel", "create ssh tunnel"
      method_option :auto, :aliases => "-a", :desc => "use autossh"
      def tunnel
        if options[:auto]
          `autossh -M 2115 -N -R 2114:localhost:22 marshally@yountlabs.com`
        else
          `ssh -fN -R 2114:localhost:22 marshally@yountlabs.com`
        end
      end

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

        say "Open http://localhost:9090"
        say "create a universe with id=1"
        say "Add the DMX USB Pro output port to it"
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

        def ola_dir
          ENV['HOME'] + "/.ola"
        end

        def test_ola
          say "Testing OLA"
          raise NotImplementedError
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
          kill_olad
          confs = ['artnet', 'e131', 'shownet', 'dummy', 'espnet', 'pathport',
            'sandnet', 'stageprofi', 'usbdmx', 'usbserial'] # 'opendmx',

          confs.each do |conf|
            file = "~/.ola/ola-#{conf}.conf"
            unless `cat #{file}`.include? "enabled"
              say "disabling #{file}"
              append_file file, 'enabled = false'
            end
          end
        end

        def kill_olad
          pid = `ps aux| grep olad | grep -v grep`.split(/\s+/)[1]
          `kill -9 #{pid}` if pid
        end
      end
    end
  end
end
