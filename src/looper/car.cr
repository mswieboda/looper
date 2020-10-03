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

    def self.acceleration
      15
    end

    def self.turning
      150
    end

    def update(frame_time)
      super(frame_time)
    end

    def draw
      @sprite.draw(
        x: x,
        y: y,
        centered: true,
        rotation: rotation
      )

      super
    end
  end
end
