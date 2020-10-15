module Looper
  abstract class Tile
    SIZE = 32

    property x : Int32 | Float32
    property y : Int32 | Float32
    property size : Int32
    property color : Game::Color

    def initialize(@x, @y, @size = SIZE, @color = Game::Color::Gray)
      @square = Game::Square.new(
        x: x,
        y: y,
        size: size,
        color: color
      )
    end

    def draw(view_x, view_y)
      @square.draw(view_x, view_y)
    end
  end
end
