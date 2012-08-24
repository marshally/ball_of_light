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
          scene.to_json.should == '{"skeletons":[{"userid":1,"joints":[{"joint":"head","X":123.0,"Y":456.0,"Z":789.0}]}]}'
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

        # real blob
        it "should decode JSON" do
          scene = Scene.new(:blob => '{"skeletons":[{"userid":0,"joints":[{"joint":"head","X":-1311.233,"Y":1104.431,"Z":3719.825},{"joint":"neck","X":-1293.761,"Y":752.423,"Z":3690.769},{"joint":"neck","X":-1293.761,"Y":752.423,"Z":3690.769},{"joint":"l_shoulder","X":-1166.604,"Y":767.164,"Z":3643.879},{"joint":"l_elbow","X":-1166.604,"Y":480.805,"Z":3643.879},{"joint":"l_elbow","X":-1166.604,"Y":480.805,"Z":3643.879},{"joint":"l_hand","X":-1166.609,"Y":194.446,"Z":3643.879},{"joint":"l_hand","X":-1166.609,"Y":194.446,"Z":3643.879},{"joint":"l_hand","X":-1166.609,"Y":194.446,"Z":3643.879},{"joint":"r_shoulder","X":-1420.918,"Y":737.683,"Z":3737.659},{"joint":"r_elbow","X":-1420.918,"Y":451.324,"Z":3737.659},{"joint":"r_elbow","X":-1420.918,"Y":451.324,"Z":3737.659},{"joint":"r_hand","X":-1420.912,"Y":164.965,"Z":3737.659},{"joint":"r_hand","X":-1420.912,"Y":164.965,"Z":3737.659},{"joint":"torso","X":-1287.677,"Y":678.597,"Z":3684.056},{"joint":"torso","X":-1287.677,"Y":678.597,"Z":3684.056},{"joint":"l_hip","X":-1188.121,"Y":615.607,"Z":3642.874},{"joint":"l_knee","X":-1159.403,"Y":167.876,"Z":3535.787},{"joint":"l_knee","X":-1159.403,"Y":167.876,"Z":3535.787},{"joint":"l_foot","X":-1120.870,"Y":-249.550,"Z":3507.282},{"joint":"r_hip","X":-1375.066,"Y":593.935,"Z":3711.811},{"joint":"r_knee","X":-1398.759,"Y":153.992,"Z":3697.139},{"joint":"r_knee","X":-1398.759,"Y":153.992,"Z":3697.139},{"joint":"r_foot","X":-1413.981,"Y":-176.626,"Z":3690.255}]},{"userid":1,"joints":[{"joint":"head","X":221.435,"Y":464.873,"Z":2364.009},{"joint":"neck","X":258.656,"Y":250.759,"Z":2437.430},{"joint":"neck","X":258.656,"Y":250.759,"Z":2437.430},{"joint":"l_shoulder","X":109.261,"Y":184.806,"Z":2302.519},{"joint":"l_elbow","X":109.262,"Y":-127.919,"Z":2302.519},{"joint":"l_elbow","X":109.262,"Y":-127.919,"Z":2302.519},{"joint":"l_hand","X":109.257,"Y":-440.644,"Z":2302.519},{"joint":"l_hand","X":109.257,"Y":-440.644,"Z":2302.519},{"joint":"l_hand","X":109.257,"Y":-440.644,"Z":2302.519},{"joint":"r_shoulder","X":408.051,"Y":316.712,"Z":2572.342},{"joint":"r_elbow","X":477.402,"Y":60.217,"Z":2650.905},{"joint":"r_elbow","X":477.402,"Y":60.217,"Z":2650.905},{"joint":"r_hand","X":442.704,"Y":-153.279,"Z":2447.204},{"joint":"r_hand","X":442.704,"Y":-153.279,"Z":2447.204},{"joint":"torso","X":287.498,"Y":29.951,"Z":2513.436},{"joint":"torso","X":287.498,"Y":29.951,"Z":2513.436},{"joint":"l_hip","X":238.526,"Y":-225.209,"Z":2519.173},{"joint":"l_knee","X":238.526,"Y":-703.495,"Z":2519.173},{"joint":"l_knee","X":238.526,"Y":-703.495,"Z":2519.173},{"joint":"l_foot","X":238.526,"Y":-1163.385,"Z":2519.173},{"joint":"r_hip","X":394.153,"Y":-156.505,"Z":2659.712},{"joint":"r_knee","X":394.153,"Y":-634.791,"Z":2659.712},{"joint":"r_knee","X":394.153,"Y":-634.791,"Z":2659.712},{"joint":"r_foot","X":394.153,"Y":-1094.681,"Z":2659.712}]},{"userid":2,"joints":[{"joint":"head","X":423.909,"Y":286.826,"Z":1344.520},{"joint":"neck","X":494.943,"Y":228.468,"Z":1191.901},{"joint":"neck","X":494.943,"Y":228.468,"Z":1191.901},{"joint":"l_shoulder","X":511.617,"Y":198.638,"Z":1148.852},{"joint":"l_elbow","X":388.914,"Y":-38.691,"Z":1150.927},{"joint":"l_elbow","X":388.914,"Y":-38.691,"Z":1150.927},{"joint":"l_hand","X":515.104,"Y":-333.388,"Z":1073.343},{"joint":"l_hand","X":515.104,"Y":-333.388,"Z":1073.343},{"joint":"l_hand","X":515.104,"Y":-333.388,"Z":1073.343},{"joint":"r_shoulder","X":478.269,"Y":258.297,"Z":1234.950},{"joint":"r_elbow","X":581.040,"Y":-41.905,"Z":1222.877},{"joint":"r_elbow","X":581.040,"Y":-41.905,"Z":1222.877},{"joint":"r_hand","X":548.886,"Y":-305.507,"Z":1122.221},{"joint":"r_hand","X":548.886,"Y":-305.507,"Z":1122.221},{"joint":"torso","X":483.652,"Y":88.810,"Z":1284.277},{"joint":"torso","X":483.652,"Y":88.810,"Z":1284.277},{"joint":"l_hip","X":496.398,"Y":-93.851,"Z":1314.592},{"joint":"l_knee","X":575.845,"Y":-527.282,"Z":1299.031},{"joint":"l_knee","X":575.845,"Y":-527.282,"Z":1299.031},{"joint":"l_foot","X":488.399,"Y":-543.106,"Z":1509.911},{"joint":"r_hip","X":448.321,"Y":-7.843,"Z":1438.716},{"joint":"r_knee","X":522.246,"Y":-333.097,"Z":1574.041},{"joint":"r_knee","X":522.246,"Y":-333.097,"Z":1574.041},{"joint":"r_foot","X":543.123,"Y":-523.964,"Z":1341.808}]},{"userid":3,"joints":[{"userid":7,"X":596.515,"Y":102.647,"Z":1161.603}
]}],"elapsed":10562.052}')
          scene.users.count.should == 4
          scene.elapsed.should == 10562.052
        end
      end
    end
  end
end
