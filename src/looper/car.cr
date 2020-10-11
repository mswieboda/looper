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
      15
    end

    def self.brakes
      10
    end

    def update(frame_time)
      super(frame_time)
    end

    def draw(view_x, view_y)
      @sprite.draw(
        x: view_x + x,
        y: view_y + y,
        centered: true,
        rotation: rotation
      )

      super(view_x, view_y)
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
