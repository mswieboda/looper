module Looper
  class IsoTrapezoid
    getter x : Int32 | Float32
    getter y : Int32 | Float32
    getter angle : Int32 | Float32
    getter base : Int32 | Float32
    getter rotation : Int32 | Float32
    getter flip : Bool

    @tris : Array(Triangle)?
    @points : Array(Circle)
    @color : Color

    def initialize(@x, @y, @angle, @base, @rotation = 0, @flip = false, @color = Color::Red)
      @points = [] of Circle
    end

    def x=(value : Int32 | Float32)
      @x = value
      @tris = nil
    end

    def tris : Array(Triangle)
      if tris = @tris
        # memoized
        # if we need to recalculate then set `@tris = nil`
        return tris
      end

      tris = [] of Triangle
      a = base / 2 # a, b from a, b, c edges in right angle
      b = a * Math.tan(Trig.to_radians(@angle))
      interior_angle = Trig.to_degrees(Math.atan(b / (a + @base)))
      triangles = [
        [
          {x: 0, y: 0, theta: @rotation},
          {x: a, y: -b, theta: @angle + @rotation},
          {x: @base, y: 0, theta: @rotation}
        ],
        [
          {x: @base, y: 0, theta: @rotation},
          {x: a, y: -b, theta: @angle + @rotation},
          {x: a + @base, y: -b, theta: interior_angle + @rotation},
        ],
        [
          {x: @base, y: 0, theta: @rotation},
          {x: a + @base, y: -b, theta: interior_angle + @rotation},
          {x: @base * 2, y: 0, theta: @rotation},
        ]
      ]

      # apply rotation
      triangles = triangles.map do |points|
        points.map do |p|
          r = Math.sqrt(p[:x] ** 2 + p[:y] ** 2)
          x = r * Math.cos(Trig.to_radians(p[:theta]))
          y = r * Math.sin(Trig.to_radians(p[:theta]))
          {x: x, y: y}
        end
      end

      # apply position
      triangles = triangles.map do |points|
        points.map do |p|
          {x: x + p[:x].to_f32, y: y - p[:y].to_f32}
        end
      end

      # create triangles
      triangles.each do |t|
        tris << Triangle.new(
          x1: t[0][:x], y1: t[0][:y],
          x2: t[1][:x], y2: t[1][:y],
          x3: t[2][:x], y3: t[2][:y],
          color: @color
        )
      end

      # create circle points
      colors = [Color::Red, Color::Green, Color::Blue]
      @points = [] of Circle
      triangles.each do |points|
        points.each_with_index do |p, index|
          @points << Circle.new(center_x: p[:x], center_y: p[:y], size: 5, filled: false, color: colors[index])
        end
      end

      @tris = tris

      tris
    end

    def collision?(obj : Obj)
      obj.collision?(tris)
    end

    def draw
      tris.each(&.draw)
      @points.each(&.draw) if Game::DEBUG
    end
  end
end
