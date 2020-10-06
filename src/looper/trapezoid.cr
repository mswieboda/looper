module Looper
  class IsoTrapezoid
    getter x : Int32 | Float32
    getter y : Int32 | Float32
    getter angle : Int32 | Float32
    getter base : Int32 | Float32
    getter rotation : Int32 | Float32
    getter flip : Bool

    @tris : Array(Triangle)?
    @color : Color

    def initialize(@x, @y, @angle, @base, @rotation = 0, @flip = false, @color = Color::Red)
    end

    def x=(value : Int32 | Float32)
      @x = value
      @tris = nil
    end

    def tris : Array(Triangle)
      if tris = @tris
        return tris
      end

      tris = [] of Triangle

      a = base / 2
      b = a * Math.tan(Trig.to_radians(@angle))

      tris << Triangle.new(
        x1: x, y1: y,
        x2: x + a.to_f32, y2: y - b.to_f32,
        x3: x + @base, y3: y,
        color: @color
      )

      @tris = tris

      tris
    end

    def draw
      tris.each(&.draw)
    end
  end
end
