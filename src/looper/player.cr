module Looper
  class Player
    getter car : Vehicle

    delegate :x, :x=, :y, :y=, :collision?, :collisions?, to: car

    def initialize(x, y)
      @car = Car.new(
        x: x,
        y: y,
      )
    end

    def update(frame_time)
      car.update(frame_time)
    end

    def draw
      car.draw
    end

    def movement(frame_time)
      if Keys.down?([Key::Up, Key::W])
        car.accelerate(frame_time)
      end

      if Keys.down?([Key::Left, Key::A])
        car.turn_left(frame_time)
      end

      if Keys.down?([Key::Right, Key::D])
        car.turn_right(frame_time)
      end

      if Keys.pressed?([Key::LShift, Key::RShift])
        car.drifting = true
      elsif Keys.released?([Key::LShift, Key::RShift])
        car.drifting = false
      end

      if Keys.pressed?([Key::Down, Key::S])
        car.braking = true
      elsif Keys.released?([Key::Down, Key::S])
        car.braking = false
      end
    end
  end
end
