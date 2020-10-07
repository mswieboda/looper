module Looper
  class Trig
    def self.to_radians(degrees : Int32 | Float32 | Float64)
      degrees * Math::PI / 180
    end

    def self.to_degrees(radians : Int32 | Float32 | Float64)
      radians * 180 / Math::PI
    end

    def self.rotate_x(x : Int32 | Float32 | Float64, degrees : Int32 | Float32 | Float64)
      x * Math.cos(to_radians(degrees))
    end

    def self.rotate_y(y : Int32 | Float32 | Float64, degrees : Int32 | Float32 | Float64)
      y * Math.sin(to_radians(degrees))
    end
  end
end
