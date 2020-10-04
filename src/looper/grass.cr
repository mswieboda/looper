require "./tile"

module Looper
  class Grass < Tile
    COLOR = Color.new(red: 43, green: 94, blue: 48)
    ACCENT_RATIO = 0.33_f32

    @accent : Accent?

    def initialize(x, y, color = COLOR)
      super(x: x, y: y, color: color)

      @accent = nil

      if rand <= ACCENT_RATIO
        @accent = Accent.new(x: x, y: y)
      end
    end

    def draw
      super

      if accent = @accent
        accent.draw
      end
    end
  end
end
