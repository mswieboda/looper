require "./obj"

module Looper
  abstract class Vehicle < Obj
    @speed : Float32
    @acceleration : Float32

    def initialize(x, y, width, height, color = Color::Red)
      super(
        x: x,
        y: y,
        width: width,
        height: height,
        color: color
      )

      @speed = 0_f32
      @acceleration = 0_f32
    end

    def self.acceleration_amount
      10
    end

    def accelerate(frame_time)
      amount = self.class.acceleration_amount

      puts ">>> accelerate, amount: #{amount}"

      @acceleration += self.class.acceleration_amount * frame_time
    end

    def update(frame_time)
    end

    def draw
    end
  end
end
