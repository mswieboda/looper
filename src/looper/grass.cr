require "./tile"

module Looper
  class Grass < Tile
    COLOR = Game::Color.new(red: 43, green: 94, blue: 48)
    ACCENT_RATIO = 0.33_f32

    @accent : GrassAccent?

    def initialize(x, y, color = COLOR)
      super(x: x, y: y, color: color)

      @accent = nil

      if rand <= ACCENT_RATIO
        @accent = GrassAccent.new(
          x: rand(x..x + size - Accent::SIZE),
          y: rand(y..y + size - Accent::SIZE)
        )
      end
    end

    def draw(view_x, view_y)
      super(view_x, view_y)

      if accent = @accent
        accent.draw(view_x, view_y)
      end
    end
  end
end
