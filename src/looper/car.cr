require "./vehicle"

module Looper
  class Car < Vehicle
    def initialize(x, y, width, height, color = Color::Red)
      super(
        x: x,
        y: y,
        width: width,
        height: height,
        color: color
      )
    end

    def self.acceleration_amount
      30
    end

    def update(frame_time)
    end

    def draw
      Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height,
        color: color
      ).draw
    end
  end
end
