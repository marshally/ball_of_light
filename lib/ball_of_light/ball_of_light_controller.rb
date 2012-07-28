require 'open_lighting'

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
      Dir.mkdir(File.dirname points_file)
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
  end
end
