require 'spec_helper'

module BallOfLight
  describe Users do
    describe ".initialize" do
      context "when passed a blob" do
        it "should serialize the values" do
          u = Users.new(:skeletons => [:userid => 1, :joints => [{:name => "head", :x => "123", :y => 456.0, :z => 789}]])
          u[0].id.should == 1
          j = u[0].joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end


        # it "should handle kinectable_pipe's format" do
        #   u = User.new("userid" => 1, "joints" => [{"joint" => "head", "X" => "123", "Y" => 456.0, "Z" => 789}])
        #   u.id.should == 1
        #   j = u.joints.first
        #   j.name.should == "head"
        #   j.x.should == 123.0
        #   j.y.should == 456.0
        #   j.z.should == 789.0
        # end

        # it "should decode JSON" do
        #   u = User.new(:blob => '{"userid":0, "joints":[{"joint": "head", "X": "123", "Y": 456.0, "Z": 789}]}')
        #   j = u.joints.first
        #   j.name.should == "head"
        #   j.x.should == 123.0
        #   j.y.should == 456.0
        #   j.z.should == 789.0
        # end
      end
    end
  end
end
