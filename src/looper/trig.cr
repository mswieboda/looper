module Looper
  class Trig
    def self.to_radians(degrees : Int32 | Float32 | Float64)
      degrees * Math::PI / 180
    end

    def self.rotate_x(degrees : Int32 | Float32 | Float64)
      Math.cos(to_radians(degrees))
    end

    def self.rotate_y(degrees : Int32 | Float32 | Float64)
      Math.sin(to_radians(degrees))
    end
  end
end
