require 'open_lighting'
require 'json'

module BallOfLight
  class BallOfLightController < OpenLighting::DmxController
    def initialize(options = {})
      super
      count = options[:count] || 12
      count.times do |i|
        self << OpenLighting::Devices::ComscanLed.new
      end

      devices.each_with_index {|device, i| device.add_points BallOfLightController.additional_points[i]}
    end

    def self.points_file
      ENV['HOME'] + "/.ball_of_light/points.json"
    end

    def self.write_points(values)
      unless Dir.exists?(File.dirname points_file)
        Dir.mkdir(File.dirname points_file)
      end
      IO.write(points_file, values.to_json)
    end

    def self.additional_points
      begin
        points = JSON.parse(IO.read(points_file)) || []
      rescue JSON::ParserError
      rescue Errno::ENOENT
      end
      points ||= []
    end

    # yellow_ring = [5, 10, 11, 7, 4, 1]
    # blue_ring   = [8, 12, 11, 6, 2, 1]
    # red_ring    = [2, 5, 9, 12, 7, 3]
    # green_ring  = [3, 4, 8, 9, 10, 6]

    def yellow_ring_lights
      [4, 9, 10, 6, 3, 0].map{|i| devices[i]}
    end

    def blue_ring_lights
      [7, 11, 10, 5, 1, 0].map{|i| devices[i]}
    end

    def red_ring_lights
      [1, 4, 8, 11, 6, 2].map{|i| devices[i]}
    end

    def green_ring_lights
      [2, 3, 7, 8, 9, 5].map{|i| devices[i]}
    end

    def top_lights
      [8,9,10,11].map{|i| devices[i]}
    end

    def bottom_lights
      [0,1,2,3].map{|i| devices[i]}
    end

    def middle_lights
      [4,5,6,7].map{|i| devices[i]}
    end
  end
end
