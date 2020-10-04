module Looper
  class RoadTurn
    property x : Int32 | Float32
    property y : Int32 | Float32

    @tris : Array(Triangle)
    @blocks : Array(Rectangle)
    @points : Array(Circle)

    def initialize(@x, @y, size = 50, h_size = 1, h_gap = 0, v_size = 1, v_gap = 0, h_flip = false, color = Color::Gray)
      @tris = [] of Triangle
      @blocks = [] of Rectangle

      triangles = [
        # top half of curve
        [
          {
            x: x + size * h_size,
            y: y + size * v_size,
            color: Color::Red
          },
          {
            x: x,
            y: h_flip ? y + size * v_size : y,
            color: Color::Green},
          {
            x: x + size * h_size,
            y: y,
            color: Color::Blue
          }
        ],
        [
          {
            x: x + size * (h_size + h_gap),
            y: y + size * v_size,
            color: Color::Red
          },
          {
            x: x + size * (h_size + h_gap),
            y: y,
            color: Color::Green
          },
          {
            x: x + size * (h_size * 2 + h_gap),
            y: h_flip ? y : y + size * v_size,
            color: Color::Blue
          }
        ],
        # bottom half of curve
        [
          {
            x: x,
            y: y + size * (v_size * (h_flip ? 1 : 2) + v_gap),
            color: Color::Red
          },
          {
            x: x + size * h_size,
            y: y + size * (v_size + v_gap),
            color: Color::Green
          },
          {
            x: x + size * h_size,
            y: y + size * (v_size * 2 + v_gap),
            color: Color::Blue
          }
        ],
        [
          {
            x: x + size * (h_size + h_gap),
            y: y + size * (v_size * 2 + v_gap),
            color: Color::Red},
          {
            x: x + size * (h_size + h_gap),
            y: y + size * (v_size + v_gap),
            color: Color::Green
          },
          {
            x: x + size * (h_size * 2 + h_gap),
            y: y + size * (v_size * (h_flip ? 2 : 1) + v_gap),
            color: Color::Blue
          }
        ],
      ]

      triangles.each do |p|
        @tris << Triangle.new(
          x1: p[0][:x],
          y1: p[0][:y],
          x2: p[1][:x],
          y2: p[1][:y],
          x3: p[2][:x],
          y3: p[2][:y],
          color: color
        )
      end

      if h_gap > 0
        @blocks << Rectangle.new(
          x: x + size * h_size,
          y: y,
          width: size * h_gap,
          height: size * v_size,
          color: color
        )
        @blocks << Rectangle.new(
          x: x + size * h_size,
          y: y + size * (v_size + v_gap),
          width: size * h_gap,
          height: size * v_size,
          color: color
        )
      end

      if v_gap > 0
        @blocks << Rectangle.new(
          x: h_flip ? x : x + size * h_size,
          y: y + size * v_size,
          width: size * h_size + size * h_gap,
          height: size * v_gap,
          color: color
        )
      end

      @points = triangles.flat_map do |triangle_points|
        triangle_points.map do |p|
          Circle.new(center_x: p[:x], center_y: p[:y], size: 5, filled: false, color: p[:color])
        end
      end
    end

    def collision?(obj : Obj)
      obj.collision?(@blocks) || obj.collision?(@tris)
    end

    def draw
      @tris.each(&.draw)
      @blocks.each(&.draw)
      @points.each(&.draw) if Game::DEBUG
    end
  end
end
