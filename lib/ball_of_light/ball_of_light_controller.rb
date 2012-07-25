require 'open_lighting'

module BallOfLight
  class BallOfLightController < OpenLighting::DmxController
    def initialize(options = {})
      super
      count = options[:count] || 12
      count.times do |i|
        self.devices << OpenLighting::Devices::ComscanLed
      end
    end
  end
end
