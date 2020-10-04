require "./tile"

module Looper
  class Grass < Tile
    COLOR = Color::Green

    def initialize(x, y, color = COLOR)
      super(x: x, y: y, color: color)
    end

    def draw
      super

      # TODO: add accents
    end
  end
end
