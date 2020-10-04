require "./tile"

module Looper
  class River < Tile
    COLOR = Color::DarkBlue

    @accent : RiverAccent

    def initialize(x, y, color = COLOR)
      super(x: x, y: y, color: color)

      @accent = RiverAccent.new(
        x: rand(x..x + size - Accent::SIZE),
        y: rand(y..y + size - Accent::SIZE)
      )
    end

    def update(frame_time)
      @accent.update(frame_time)
    end

    def draw
      super

      @accent.draw
    end
  end
end
