require 'spec_helper'

module BallOfLight
  describe Joint do
    describe ".initialize" do
      context "when passed a blob" do
        it "should serialize the values" do
          j = Joint.new(:name => "head", :x => "123", :y => 456.0, :z => 789)
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0

          j.to_json.should == '{"joint":"head","X":123.0,"Y":456.0,"Z":789.0}'
        end

        it "should handle kinectable_pipe's format" do
          j = Joint.new("joint" => "head", "X" => "123", "Y" => 456.0, "Z" => 789)
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0

        end

        it "should decode JSON" do
          j = Joint.new(:blob => '{"joint": "head", "X": "123", "Y": 456.0, "Z": 789}')
          j.name.should == "head"
          j.x.should == 123.0
          j.y.should == 456.0
          j.z.should == 789.0
        end
      end

      context "when passed incomplete data" do
        j = Joint.new(:blob => '{"joint": "head", "Y": 456.0, "Z": 789}')
        j.x.should == nil
      end
    end

    describe ".vector" do
      context "with incomplete values" do
        j = Joint.new(:name => "head", :x => "123", :z => 789)
        j.vector.should == nil
      end
    end
  end
end
