module Looper
  class RiverAccent < Accent
    def initialize(x, y)
      super(x: x, y: y, sprite: Sprite.get(:river_accents))
    end

    def update(frame_time)
      @sprite.update(frame_time)
    end
  end
end
