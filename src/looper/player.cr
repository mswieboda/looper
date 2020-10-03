module Looper
  class Player
    getter car : Vehicle

    delegate :x, :x=, :y, :y=, to: car

    def initialize(x, y, color = Color::Red)
      @car = Car.new(
        x: x,
        y: y,
        width: 64,
        height: 24,
        color: color
      )
    end

    def update(frame_time)
      if Keys.down?([Key::Up, Key::W])
        car.accelerate(frame_time)
      end

      car.update(frame_time)
    end

    def draw
      car.draw
    end
  end
end
