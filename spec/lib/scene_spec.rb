require 'spec_helper'

module BallOfLight
  describe Scene do
    describe ".initialize" do
      context "when passed a blob" do
        it "should serialize the values" do
          scene = Scene.new(:skeletons => [:userid => 1, :joints => [{:name => "head", :x => "123", :y => 456.0, :z => 789}]])
          user = scene.users[0]
          user.id.should == 1
          j = user.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
          scene.to_json.should == '{"skeletons":[{"userid":1,"joints":{"joint":"head","X":123.0,"Y":456.0,"Z":789.0}}]}'
        end


        it "should handle kinectable_pipe's format" do
          scene = Scene.new(:skeletons => [:userid => 1, :joints => [{:joint => "head", :x => "123", :y => 456.0, :z => 789}]])
          user = scene.users[0]
          user.id.should == 1
          j = user.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end

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
