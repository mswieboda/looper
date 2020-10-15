require "./tile"

module Looper
  abstract class Accent
    SIZE = 8

    property x : Int32 | Float32
    property y : Int32 | Float32
    getter sprite : Game::Sprite

    delegate :width, :height, to: sprite

    def initialize(@x, @y, @sprite)
    end

    def draw(view_x, view_y)
      @sprite.draw(
        x: view_x + x,
        y: view_y + y
      )
    end
  end
end
