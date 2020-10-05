module Looper
  class Player
    getter car : Vehicle

    delegate :x, :x=, :y, :y=, :collision?, :collisions?, :input, to: car

    def initialize(x, y)
      @car = Car.new(
        x: x,
        y: y,
        player: true
      )
    end

    def update(frame_time)
      car.update(frame_time)
    end

    def draw
      car.draw
    end
  end
end
