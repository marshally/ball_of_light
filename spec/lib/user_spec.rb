require 'spec_helper'

module BallOfLight
  describe User do
    describe ".initialize" do
      context "when passed a blob" do
        # FIXME
        # considering to deprecate this format
        it "should serialize the values" do
          u = User.new(:userid => 1, :joints => [{:name => "head", :x => "123", :y => 456.0, :z => 789}])
          u.id.should == 1

          j = u.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0

          u.to_json.should == "{\"userid\":1,\"joints\":[{\"joint\":\"head\",\"X\":123.0,\"Y\":456.0,\"Z\":789.0}]}"
        end

        it "should handle kinectable_pipe's format" do
          u = User.new("userid" => 1, "joints" => [{"joint" => "head", "X" => "123", "Y" => 456.0, "Z" => 789}])
          u.id.should == 1

          j = u.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0

          u.to_json.should == "{\"userid\":1,\"joints\":[{\"joint\":\"head\",\"X\":123.0,\"Y\":456.0,\"Z\":789.0}]}"
        end

        it "should decode JSON" do
          u = User.new(:blob => '{"userid":0, "joints":[{"joint": "head", "X": "123", "Y": 456.0, "Z": 789}]}')

          j = u.joints[:head]
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end

        it "should handle bad JSON encoding from kinectable_pipe 0.0.4" do
          u = User.new(:blob => '{"userid":3,"joints":[{"userid":7,"X":595.137,"Y":97.901,"Z":1158.847}]}')

          u.joints.empty?.should == true
          u.center_of_mass[:X].should == 595.137
          u.id.should == 7

          u.to_json.should == "{\"userid\":7,\"X\":595.137,\"Y\":97.901,\"Z\":1158.847}"
        end

        it "should decode center of mass format JSON" do
          u = User.new(:blob => "{\"userid\":7,\"X\":595.137,\"Y\":97.901,\"Z\":1158.847}")

          u.to_json.should == "{\"userid\":7,\"X\":595.137,\"Y\":97.901,\"Z\":1158.847}"
        end
      end
    end

    describe ".facing" do
      context "when facing a direction" do
          u = User.new(:userid => 1,
                       :joints => [
                                    {:name => "head",       :x =>  1, :y => 2, :z => 1},
                                    {:name => "l_shoulder", :x =>  2, :y => 1, :z => 1},
                                    {:name => "r_shoulder", :x => -3, :y => 1, :z => 1},
                                  ])
          u.facing.should == Vector[0.0, 0.0, 1.0]
      end
    end

    describe ".right_forearm_vector" do
      it "should recognize right forearmarm vector" do
        # r_shoulder, r_elbow, r_hand
        u = User.new(:userid => 1,
                     :joints => [
                                  {:name => "r_elbow",    :x => 2, :y => 2, :z => 2},
                                  {:name => "r_hand",     :x => 3, :y => 3, :z => 3}
                                ])

        u.right_fore_arm_vector.should == Vector[1.0, 1.0, 1.0]
      end
    end

    describe ".pointing" do
      context "when pointing at something" do
        it "should recognize right arm pointing" do
          # r_shoulder, r_elbow, r_hand
          u = User.new(:userid => 1,
                       :joints => [
                                    {:name => "r_shoulder", :x => 1, :y => 1.2, :z => 1.301},
                                    {:name => "r_elbow",    :x => 2, :y => 2.201, :z => 2.1},
                                    {:name => "r_hand",     :x => 3, :y => 3.2, :z => 3.3},
                                  ])

          u.pointing_right.should == Vector[0.5393205896402612, 0.538781269050621, 0.6471847075683134]
        end

        # it "should recognize left arm pointing" do
        #   # r_shoulder, r_elbow, r_hand
        #   u = User.new(:userid => 1,
        #                :joints => [
        #                             {:name => "l_shoulder", :x => 1, :y => 1, :z => 1},
        #                             {:name => "l_elbow",    :x => 2, :y => 2, :z => 2},
        #                             {:name => "l_hand",     :x => 3, :y => 3, :z => 3},
        #                           ])
        #   u.pointing.should == Vector[0.5773502691896258, 0.5773502691896258, 0.5773502691896258]
        # end

        it "should fail if vectors are exactly the same" do
          # r_shoulder, r_elbow, r_hand
          u = User.new(:userid => 1,
                       :joints => [
                                    {:name => "r_shoulder", :x => 1, :y => 1, :z => 1},
                                    {:name => "r_elbow",    :x => 2, :y => 2, :z => 2},
                                    {:name => "r_hand",     :x => 3, :y => 3, :z => 3},
                                  ])
          u.pointing.should == nil
        end
      end
    end
  end
end
