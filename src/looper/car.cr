require "./vehicle"

module Looper
  class Car < Vehicle
    @sprite : Sprite

    def initialize(x, y)
      super(
        x: x,
        y: y,
        width: 64,
        height: 24,
      )

      @sprite = Sprite.get(:car)
    end

    def self.acceleration_amount
      30
    end

    def update(frame_time)
      super(frame_time)
    end

    def draw
      @sprite.draw(
        x: x,
        y: y,
        rotation: rotation
      )
    end
  end
end
