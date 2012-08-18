# {"skeletons":[{"userid":0,"joints":[{"joint":"head","X":-184.015,"Y":658.383,"Z":1432.966},{"joint":"neck","X":-157.280,"Y":423.314,"Z":1514.067},{"joint":"neck","X":-157.280,"Y":423.314,"Z":1514.067},{"joint":"l_shoulder","X":-321.373,"Y":390.215,"Z":1559.495},{"joint":"l_elbow","X":-419.761,"Y":258.850,"Z":1335.723},{"joint":"l_elbow","X":-419.761,"Y":258.850,"Z":1335.723},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"r_shoulder","X":6.814,"Y":456.412,"Z":1468.639},{"joint":"r_elbow","X":-53.036,"Y":237.648,"Z":1357.821},{"joint":"r_elbow","X":-53.036,"Y":237.648,"Z":1357.821},{"joint":"r_hand","X":-301.554,"Y":307.065,"Z":1005.167},{"joint":"r_hand","X":-301.554,"Y":307.065,"Z":1005.167},{"joint":"torso","X":-140.390,"Y":260.839,"Z":1456.696},{"joint":"torso","X":-140.390,"Y":260.839,"Z":1456.696},{"joint":"l_hip","X":-201.483,"Y":82.636,"Z":1420.915},{"joint":"l_knee","X":-203.768,"Y":-279.789,"Z":1426.475},{"joint":"l_knee","X":-203.768,"Y":-279.789,"Z":1426.475},{"joint":"l_foot","X":-155.155,"Y":-667.994,"Z":1562.171},{"joint":"r_hip","X":-45.518,"Y":114.095,"Z":1377.737},{"joint":"r_knee","X":97.158,"Y":-251.251,"Z":1325.707},{"joint":"r_knee","X":97.158,"Y":-251.251,"Z":1325.707},{"joint":"r_foot","X":198.733,"Y":-662.906,"Z":1416.112}]}],"elapsed":3.117}
# or
#
class User
  attr_accessor :id, :joints
  def initialize(options = {})
    if options[:blob]
      blob = JSON.parse options[:blob]
      options.merge! blob
    end
    options.symbolize_keys!

    self.id = options[:userid]
    if options[:joints]
      self.joints = options[:joints].inject({}) do |result, j|
        joint = Joint.new(j)
        result[joint.name.to_sym] = joint
        result
      end
    end
  end

  def pointing
    pointing_right || pointing_left
  end

  def pointing_right
    return nil if joints[:r_hand].z     == joints[:r_elbow].z
    return nil if joints[:r_shoulder].z == joints[:r_elbow].z
    return nil if joints[:r_hand].z     == joints[:r_shoulder].z
    direction_equivalent(right_fore_arm_vector, right_upper_arm_vector)
  end

  def right_fore_arm_vector
    vector_between(:r_hand, :r_elbow)
  end

  def right_upper_arm_vector
    vector_between(:r_elbow, :r_shoulder)
  end

  def pointing_left
    [:l_hand, :l_elbow, :l_hand].each {|j| return nil if joints[j].nil?}
    return nil if joints[:l_hand].z     == joints[:l_elbow].z
    return nil if joints[:l_shoulder].z == joints[:l_elbow].z
    return nil if joints[:l_hand].z     == joints[:l_shoulder].z
    direction_equivalent(vector_between(:l_hand, :l_elbow), vector_between(:l_elbow, :l_shoulder))
  end

  def vector_between(sym1, sym2)
    if joints[sym1] && joints[sym2]
      if joints[sym1].vector && joints[sym2].vector
        joints[sym1].vector - joints[sym2].vector
      end
    end
  end

  def direction_equivalent(v1, v2, err=0.20)
    if v1 && v2
      v1n = v1.normalize
      v2n = v2.normalize

      3.times do |i|
        diff = (v1n[i] - v2n[i]).abs

        # there is a check against diff=0 here because the depth readings can
        # get screwed up and start yielding the exact same values
        if diff >= err || diff == 0.0
          return nil
        end
      end

      return v1n
    end
  end

end
