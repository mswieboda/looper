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
      15
    end

    def self.max_acceleration
      50
    end

    def self.drag
      5
    end

    def self.turning
      100
    end

    def accelerate(frame_time)
      @acceleration += self.class.acceleration * frame_time
    end

    def turn_left(frame_time)
      turn(-frame_time)
    end

    def turn_right(frame_time)
      turn(frame_time)
    end

    def turn(time_and_direction)
      return unless @acceleration > 0

      @rotation += self.class.turning * time_and_direction
    end

    def update(frame_time)
      movement(frame_time)
    end

    def movement(frame_time)
      return unless @acceleration > 0

      @x += Trig.rotate_x(rotation) * @acceleration
      @y += Trig.rotate_y(rotation) * @acceleration

      # reduce acceleration each frame
      @acceleration -= (self.class.drag * frame_time)
      @acceleration = @acceleration.clamp(0, self.class.max_acceleration)
    end

    def draw
      super
    end
  end
end
