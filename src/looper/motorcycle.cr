require "./vehicle"

module Looper
  class Motorcycle < Vehicle
    @sprite : Game::Sprite

    def initialize(x, y, player = false)
      super(
        x: x,
        y: y,
        width: 56,
        height: 24,
        player: player,
      )

      @sprite = Game::Sprite.get(:motorcycle)
    end

    def self.acceleration
      25
    end

    def self.turning
      100
    end

    def self.drift
      10
    end

    def self.brakes
      20
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

      Game::Rectangle.new(
        x: x - max / 2_f32,
        y: y - max / 2_f32,
        width: max,
        height: max,
        color: Game::Color::Red,
        filled: false
      )
    end
  end
end
