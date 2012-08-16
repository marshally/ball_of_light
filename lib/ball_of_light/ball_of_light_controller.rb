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
          points.symbolize_keys!

          points.values.each{|v| v.symbolize_keys! if v.is_a? Hash}
        end

        if devices[i] && points
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

    def random_color
      self.colors.shuffle[0]
    end

    def colors
      [:yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings]
    end

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

    def left_lights
      [0,3,7,8,11].map{|i| devices[i]}
    end

    def right_lights
      [1,2,5,9,10].map{|i| devices[i]}
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
          begin_animation!(:seconds => 0.25) do |c|
            c.devices.each do |device|
              device.buffer(:pan  => i*(device.points[direction][:pan] - device.points[:bottom][:pan]) + device.points[:bottom][:pan])
              device.buffer(:tilt => i*(device.points[direction][:tilt] - device.points[:bottom][:tilt]) + device.points[:bottom][:tilt])
            end
          end
        end
      end
    end

    def spiral_in
      animate!(:seconds => 2.5, :point => :right)
      [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1].each do |i|
        [:right, :back, :left, :front].each do |direction|
          begin_animation!(:seconds => 0.25) do |c|
            c.devices.each do |device|
              device.buffer(:pan  => i*(device.points[direction][:pan]  - device.points[:bottom][:pan]) + device.points[:bottom][:pan])
              device.buffer(:tilt => i*(device.points[direction][:tilt] - device.points[:bottom][:tilt]) + device.points[:bottom][:tilt])
            end
          end
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
          e.yield 30
          e.yield 255
          e.yield 255
          e.yield 0
          e.yield 25
          e.yield 50
          e.yield 75
          e.yield 45
          e.yield 40
          e.yield 37
          e.yield 35
          e.yield 33
          e.yield 30
          e.yield 27
          e.yield 24
          e.yield 21
          e.yield 18
          e.yield 15
          e.yield 12
          e.yield 9
          e.yield 8
          e.yield 7
          e.yield 6
          e.yield 5
          e.yield 4
          e.yield 3
          e.yield 2
          e.yield 1
          e.yield 1
          e.yield 1
        end
      end
    end
  end
end
