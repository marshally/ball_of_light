require 'matrix'
# {"skeletons":[{"userid":0,"joints":[{"joint":"head","X":-184.015,"Y":658.383,"Z":1432.966},{"joint":"neck","X":-157.280,"Y":423.314,"Z":1514.067},{"joint":"neck","X":-157.280,"Y":423.314,"Z":1514.067},{"joint":"l_shoulder","X":-321.373,"Y":390.215,"Z":1559.495},{"joint":"l_elbow","X":-419.761,"Y":258.850,"Z":1335.723},{"joint":"l_elbow","X":-419.761,"Y":258.850,"Z":1335.723},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"l_hand","X":-516.957,"Y":383.857,"Z":1113.725},{"joint":"r_shoulder","X":6.814,"Y":456.412,"Z":1468.639},{"joint":"r_elbow","X":-53.036,"Y":237.648,"Z":1357.821},{"joint":"r_elbow","X":-53.036,"Y":237.648,"Z":1357.821},{"joint":"r_hand","X":-301.554,"Y":307.065,"Z":1005.167},{"joint":"r_hand","X":-301.554,"Y":307.065,"Z":1005.167},{"joint":"torso","X":-140.390,"Y":260.839,"Z":1456.696},{"joint":"torso","X":-140.390,"Y":260.839,"Z":1456.696},{"joint":"l_hip","X":-201.483,"Y":82.636,"Z":1420.915},{"joint":"l_knee","X":-203.768,"Y":-279.789,"Z":1426.475},{"joint":"l_knee","X":-203.768,"Y":-279.789,"Z":1426.475},{"joint":"l_foot","X":-155.155,"Y":-667.994,"Z":1562.171},{"joint":"r_hip","X":-45.518,"Y":114.095,"Z":1377.737},{"joint":"r_knee","X":97.158,"Y":-251.251,"Z":1325.707},{"joint":"r_knee","X":97.158,"Y":-251.251,"Z":1325.707},{"joint":"r_foot","X":198.733,"Y":-662.906,"Z":1416.112}]}],"elapsed":3.117}
class Joint
  attr_accessor :x, :y, :z, :name
  def initialize(options = {})
    if options[:blob]
      blob = JSON.parse(options.delete(:blob))
      options.merge! blob
    end
    options.symbolize_keys!

    [:x, :y, :z, :X, :Y, :Z].each do |i|
      if options[i].nil? || options[i]==0.0
        options.delete(i)
      else
        options[i] = options[i].to_f
      end
    end

    self.x    = options[:x] || options[:X]
    self.y    = options[:y] || options[:Y]
    self.z    = options[:z] || options[:Z]
    self.name = options[:name] || options[:joint]
  end

  def vector
    if self.x && self.y && self.z
      if self.x!=0.0 && self.y!=0.0 && self.z!=0.0
        Vector[self.x, self.y, self.z]
      end
    end
  end

  def as_json
    {
      :joint => self.name,
      :X => self.x,
      :Y => self.y,
      :Z => self.z
    }
  end

  def to_json
    as_json.to_json
  end
end
