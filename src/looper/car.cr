require "./vehicle"

module Looper
  class Car < Vehicle
    @sprite : Sprite

    def initialize(x, y, player = false)
      super(
        x: x,
        y: y,
        width: 56,
        height: 24,
        player: player,
      )

      @sprite = Sprite.get(:car)
    end

    def self.acceleration
      15
    end

    def self.turning
      150
    end

    def self.drift
      10
    end

    def self.brakes
      15
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

    def hit_box
      max = [width, height].max / 2_f32

      Rectangle.new(
        x: x - max / 2_f32,
        y: y - max / 2_f32,
        width: max,
        height: max,
        color: Color::Red,
        filled: false
      )
    end
  end
end
