require 'spec_helper'

module BallOfLight
  describe User do
    describe ".initialize" do
      context "when passed a blob" do
        it "should serialize the values" do
          u = User.new(:userid => 1, :joints => [{:name => "head", :x => "123", :y => 456.0, :z => 789}])
          u.id.should == 1

          j = u.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end

        it "should handle kinectable_pipe's format" do
          u = User.new("userid" => 1, "joints" => [{"joint" => "head", "X" => "123", "Y" => 456.0, "Z" => 789}])
          u.id.should == 1

          j = u.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end

        it "should decode JSON" do
          u = User.new(:blob => '{"userid":0, "joints":[{"joint": "head", "X": "123", "Y": 456.0, "Z": 789}]}')

          j = u.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end
      end
    end

    describe ".pointing" do
      context "when pointing at something" do
        it "should recognize right arm pointing" do
          # r_shoulder, r_elbow, r_hand
          u = User.new(:userid => 1,
                       :joints => [
                                    {:name => "r_shoulder", :x => 1, :y => 1, :z => 1},
                                    {:name => "r_elbow",    :x => 2, :y => 2, :z => 2},
                                    {:name => "r_hand",     :x => 3, :y => 3, :z => 3},
                                  ])
          u.pointing.should == Vector[0.5773502691896258, 0.5773502691896258, 0.5773502691896258]
        end

        it "should recognize left arm pointing" do
          # r_shoulder, r_elbow, r_hand
          u = User.new(:userid => 1,
                       :joints => [
                                    {:name => "l_shoulder", :x => 1, :y => 1, :z => 1},
                                    {:name => "l_elbow",    :x => 2, :y => 2, :z => 2},
                                    {:name => "l_hand",     :x => 3, :y => 3, :z => 3},
                                  ])
          u.pointing.should == Vector[0.5773502691896258, 0.5773502691896258, 0.5773502691896258]
        end
      end
    end
  end
end
