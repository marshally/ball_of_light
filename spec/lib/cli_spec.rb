require 'spec_helper'
require 'thor'

module BallOfLight
  describe CLI do
    describe ".initialize" do
      it "should output help" do
        help = capture(:stdout) { BallOfLight::CLI::App.start }
        help.include?(" calibrate").should == true
        help.include?(" kinect").should == true
        help.include?(" setup").should == true
        help.include?(" lights").should == true
        help.include?(" upgrade").should == true
      end
    end
  end
end
