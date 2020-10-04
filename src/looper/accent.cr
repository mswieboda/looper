require "./tile"

module Looper
  abstract class Accent
    SIZE = 8

    property x : Int32 | Float32
    property y : Int32 | Float32
    getter sprite : Sprite

    delegate :width, :height, to: sprite

    def initialize(@x, @y, @sprite)
    end

    def draw
      @sprite.draw(x: x, y: y)
    end
  end
end
