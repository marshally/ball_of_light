require 'thor'
require 'open3'
module BallOfLight
  module CLI
    class Kinect < Thor
      desc "image", "display an image from the Kinect"
      def image
        cmd = "#{ENV['HOME']}/Projects/kinectable_pipe/kinectable_pipe -r 4"
        puts "waiting ..."
        stdin, stdout, wait = Open3.popen2e(cmd)
        stdout.sync = true
        STDOUT.sync = true

        ["rgb", "depth"].each do |img|
          File.delete("#{img}.png") if File.exists?("#{img}.png")
        end

        until File.exists?("rgb.png") && File.exists?("depth.png")
          line = stdout.gets "\n"
          puts "waiting ..."
          sleep(0.5) if line.include?("writing images")
        end

        `open rgb.png`
      end
    end
  end
end
