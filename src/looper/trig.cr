module Looper
  class Trig
    def self.to_radians(degrees)
      degrees * Math::PI / 180_f32
    end

    def self.rotate_x(degrees : Int32 | Float32)
      Math.cos(to_radians(degrees)).to_f32
    end

    def self.rotate_y(degrees : Int32 | Float32)
      Math.sin(to_radians(degrees)).to_f32
    end
  end
end
