module Looper
  class RoadCorner
    property x : Int32 | Float32
    property y : Int32 | Float32

    @corner : Triangle
    @points : Array(Circle)

    def initialize(@x, @y, size = 50, h_size = 1, v_size = 1, h_flip = false, v_flip = false, color = Color::Gray)
      points = [
        {x: h_flip && v_flip ? x + size * h_size : x, y: y + size * v_size, color: Color::Red},
        {x: h_flip && !v_flip ? x + size * h_size : x, y: y, color: Color::Green},
        {x: x + size * h_size, y: v_flip ? y : y + size * v_size, color: Color::Blue}
      ]

      @corner = Triangle.new(
        x1: points[0][:x],
        y1: points[0][:y],
        x2: points[1][:x],
        y2: points[1][:y],
        x3: points[2][:x],
        y3: points[2][:y],
        color: color
      )

      point_colors = [Color::Red, Color::Green, Color::Blue]
      @points = points.map_with_index do |p, index|
        Circle.new(center_x: p[:x], center_y: p[:y], size: 5, filled: false, color: point_colors[index])
      end
    end

    def draw
      @corner.draw
      @points.each(&.draw) if Game::DEBUG
    end
  end
end
