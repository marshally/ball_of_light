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

    describe '.method_missing' do
      before(:each) do
        @ball_of_light = BallOfLightController.new(:count => 2, :cmd => "> /dev/null")
      end

      context "when dimming the light" do
        it "should pass through buffer commands" do
          @ball_of_light.buffer(:dimmer => 200)
          @ball_of_light.to_dmx.should == "127,127,8,0,200,127,127,8,0,200"
          @ball_of_light.dimmer 201
          @ball_of_light.to_dmx.should == "127,127,8,0,201,127,127,8,0,201"
          @ball_of_light.dimmer!(202)
          @ball_of_light.to_dmx.should == "127,127,8,0,202,127,127,8,0,202"
        end
      end
    end

    describe '#additional_points' do
      context 'when there is no points file' do
        it 'should have normal points' do
          BallOfLightController.stub!(:points_file_contents).and_return("")
          @ball_of_light = BallOfLightController.new(:count => 2, :cmd => "> /dev/null")
          @ball_of_light.points.should == [:center, :origin, :strobe_blackout, :strobe_open, :strobe_slow, :strobe_fast, :strobe_slow_fast, :strobe_fast_slow, :strobe_random, :nocolor, :white, :yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings, :on, :off]
        end
      end

      context 'when there is a points file' do
        it 'should have normal points' do
          BallOfLightController.stub!(:points_file_contents).and_return('[{"bottom":{"pan":127,"tilt":127},"awesomeness":{"pan":116,"tilt":123}},{"bottom":{"pan":114,"tilt":125},"awesomeness":{"pan":143,"tilt":119}},{"awesomeness":{"pan":144,"tilt":127}}]')
          @ball_of_light = BallOfLightController.new(:count => 2, :cmd => "> /dev/null")
          @ball_of_light.points.should == [:center, :origin, :strobe_blackout, :strobe_open, :strobe_slow, :strobe_fast, :strobe_slow_fast, :strobe_fast_slow, :strobe_random, :nocolor, :white, :yellow, :red, :green, :blue, :teardrop, :polka, :teal, :rings, :on, :off, :bottom, :awesomeness]
        end
      end
    end
  end
end
