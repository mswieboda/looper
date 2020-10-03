module Looper
  class Player
    getter car : Vehicle

    delegate :x, :x=, :y, :y=, to: car

    def initialize(x, y)
      @car = Car.new(
        x: x,
        y: y,
      )
    end

    def update(frame_time, roads : Array(Obj))
      unless car.collision?(roads)
        puts ">>> off road!"
      end

      if Keys.down?([Key::Up, Key::W])
        car.accelerate(frame_time)
      end

      if Keys.down?([Key::Left, Key::A])
        car.turn_left(frame_time)
      end

      if Keys.down?([Key::Right, Key::D])
        car.turn_right(frame_time)
      end

      car.update(frame_time)
    end

    def draw
      car.draw
    end
  end
end
