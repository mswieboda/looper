module Looper
  abstract class Tile
    SIZE = 32

    property x : Int32 | Float32
    property y : Int32 | Float32
    property size : Int32
    property color : Color

    def initialize(@x, @y, @size = SIZE, @color = Color::Gray)
    end

    def draw
      Square.new(
        x: x,
        y: y,
        size: size,
        color: color
      ).draw
    end
  end
end
