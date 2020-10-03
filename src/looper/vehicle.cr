require "./obj"

module Looper
  abstract class Vehicle < Obj
    property rotation : Int32 | Float32

    @speed : Int32 | Float32
    @acceleration : Int32 | Float32

    def initialize(x, y, width, height, color = Color::Red)
      super(
        x: x,
        y: y,
        width: width,
        height: height,
        color: color
      )

      @speed = 0
      @acceleration = 0
      @rotation = 0
    end

    def self.acceleration
      10
    end

    def self.max_acceleration
      100
    end

    def self.drag
      5
    end

    def self.turning
      30
    end

    def accelerate(frame_time)
      @acceleration += self.class.acceleration * frame_time
    end

    def turn_left(frame_time)
      @rotation -= self.class.turning * frame_time
    end

    def turn_right(frame_time)
      @rotation += self.class.turning * frame_time
    end

    def update(frame_time)
      if @acceleration > 0
        @x += @acceleration

        # reduce acceleration each frame
        @acceleration -= (self.class.drag * frame_time)
        @acceleration = @acceleration.clamp(0, self.class.max_acceleration)
      end
    end

    def draw
    end
  end
end
