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

      BallOfLightController.additional_points.each_with_index do |points, i|
        if points.is_a? Hash
          points.values.each{|v| v.symbolize_keys!}
        end

        if devices[i]
          devices[i].points.merge! points.symbolize_keys!
        end
      end
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

    def self.points_file_contents
      IO.read(points_file)
    end

    def self.additional_points
      begin
        points = JSON.parse(points_file_contents) || []
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

    def chase_sequence
      [
        4, 9, 10, 6, 3, 0,
        4, 9, 10, 6, 3, 0,
        4, 9, 10, 6, 3, 0,
        7, 11, 10, 5, 0,
        7, 11, 10, 5, 0,
        7, 11, 10, 5,
        1, 4, 8, 11, 6, 2,
        1, 4, 8, 11, 6, 2,
        1, 4, 8, 11, 6, 2,
        5, 9, 8, 7, 3, 0,
        5, 9, 8, 7, 3, 0,
        5, 9, 8, 7, 3, 0
      ].map{|i| devices[i]}
    end

    def spiral_out
      animate!(:seconds => 2.5, :point => :bottom)
      [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0].each do |i|
        [:front, :left, :back, :right].each do |direction|
          animate!(:seconds => 0.25,
            :pan  => i*(points[direction][:pan]  - points[:bottom][:pan])  + points[:bottom][:pan],
            :tilt => i*(points[direction][:tilt] - points[:bottom][:tilt]) + points[:bottom][:tilt],
          )
        end
      end
    end

    def spiral_in
      animate!(:seconds => 2.5, :point => :right)
      [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1].each do |i|
        [:right, :back, :left, :front].each do |direction|
          animate!(:seconds => 0.25,
            :pan  => i*(points[direction][:pan]  - points[:bottom][:pan])  + points[:bottom][:pan],
            :tilt => i*(points[direction][:tilt] - points[:bottom][:tilt]) + points[:bottom][:tilt],
          )
        end
      end
      animate!(:seconds => 2.5, :point => :bottom)
    end

    def heartbeat!
      30.times do
        animate!(:seconds => 0.05, :dimmer => heartbeat.next)
      end
    end

    # heartbeat is a series of 0.05 second transitions
    def heartbeat
      @heartbeat ||= Enumerator.new do |e|
        loop do
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 255
          e.yield 0
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 255
          e.yield 0
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
          e.yield 25
        end
      end
    end
  end
end
