# {"skeletons":[{"userid":0,"joints":[{"joint":"head","X":-184.015,"Y":658.383,"Z":1432.966},{"joint":"neck","X":-157.280,"Y":423.314,"Z":1514.067},{"joint":"neck","X":-157.280,"Y":423.314,"Z":1514.067},{"joint":"l_shoulder","X":-321.373,"Y":390.215,"Z":1559.495},{"joint":"l_elbow","X":-419.761,"Y":258.850,"Z":1335.723},{"joint":"l_elbow","X":-419.761,"Y":258.850,"Z":1335.723},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"r_shoulder","X":6.814,"Y":456.412,"Z":1468.639},{"joint":"r_elbow","X":-53.036,"Y":237.648,"Z":1357.821},{"joint":"r_elbow","X":-53.036,"Y":237.648,"Z":1357.821},{"joint":"r_hand","X":-301.554,"Y":307.065,"Z":1005.167},{"joint":"r_hand","X":-301.554,"Y":307.065,"Z":1005.167},{"joint":"torso","X":-140.390,"Y":260.839,"Z":1456.696},{"joint":"torso","X":-140.390,"Y":260.839,"Z":1456.696},{"joint":"l_hip","X":-201.483,"Y":82.636,"Z":1420.915},{"joint":"l_knee","X":-203.768,"Y":-279.789,"Z":1426.475},{"joint":"l_knee","X":-203.768,"Y":-279.789,"Z":1426.475},{"joint":"l_foot","X":-155.155,"Y":-667.994,"Z":1562.171},{"joint":"r_hip","X":-45.518,"Y":114.095,"Z":1377.737},{"joint":"r_knee","X":97.158,"Y":-251.251,"Z":1325.707},{"joint":"r_knee","X":97.158,"Y":-251.251,"Z":1325.707},{"joint":"r_foot","X":198.733,"Y":-662.906,"Z":1416.112}]}],"elapsed":3.117}
# or
#
require 'json'

class User
  attr_accessor :id, :joints, :gestures, :x, :y, :z
  def initialize(options = {})
    self.gestures = options[:gestures] || []
    if options[:blob]
      blob = JSON.parse options[:blob]
      options.merge! blob
    end
    options.symbolize_keys!

    self.id = options[:userid]
    if options[:joints]
      self.joints = options[:joints].inject({}) do |result, j|
        j.symbolize_keys!
        if j[:joint] || j[:name]
          joint = Joint.new(j)
          result[joint.name.to_sym] = joint
        elsif j[:userid]
          # this is an error case due to bug in kinectable_pipe 0.0.4
          self.id = j[:userid]
          self.x = j[:X]
          self.y = j[:Y]
          self.z = j[:Z]
        end
        result
      end
    else
      self.joints = []
    end

    if options[:X] && options[:Y] && options[:X]
      self.x = options[:X]
      self.y = options[:Y]
      self.z = options[:Z]
    end
  end

  def center_of_mass
    if (self.x && self.y && self.z)
      {
        :X => self.x,
        :Y => self.y,
        :Z => self.z,
      }
    end
  end

  def as_json
    {
      :userid => self.id,
      :gestures => self.gestures,
      :joints => self.joints.inject([]){|result, j| result << j.last.as_json}
    }.merge(center_of_mass || {}).reject{|k,v| v == [] || v == {}}
  end

  # FIXME: this seems unnecessary?!?
  def to_json
    as_json.to_json
  end

  def pointing
    pointing_right || pointing_left
  end

  def facing
    head = joints[:head].vector
    r_shoulder = joints[:r_shoulder].vector
    l_shoulder = joints[:l_shoulder].vector

    if head && l_shoulder && r_shoulder
      left = l_shoulder - head
      right = r_shoulder - head
      cross_product(right, left).normalize
    end
  end

  def cross_product(v, w)
    x = v[1]*w[2] - v[2]*w[1]
    y = v[2]*w[0] - v[0]*w[2]
    z = v[0]*w[1] - v[1]*w[0]
    Vector[x,y,z]
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
