require 'spec_helper'

module BallOfLight
  describe BallOfLightController do
    describe ".initialize" do
      context "when not passing a count" do
        it "should have the default count" do
          BallOfLightController.new.devices.count.should == 12
        end
      end

      context "when passing a count" do
        it "should have the correct count" do
          BallOfLightController.new(:count => 4).devices.count.should == 4
        end
      end
    end
  end
end
