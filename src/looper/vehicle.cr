require "./obj"

module Looper
  abstract class Vehicle < Obj
    property rotation : Int32 | Float32
    getter last_rotation : Int32 | Float32
    property? drifting
    property? braking

    @speed : Int32 | Float32
    @acceleration : Int32 | Float32

    def initialize(x, y, width, height)
      super(
        x: x,
        y: y,
        width: width,
        height: height
      )

      @speed = 0
      @acceleration = 0
      @rotation = 0
      @last_rotation = 0
      @drifting = false
      @braking = false
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

    def self.drift
      10
    end

    def accelerate(frame_time)
      return if braking?
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

      # last rotation used for drifting
      @last_rotation += (rotation - last_rotation) * self.class.drift * frame_time

      if drifting?
        @x += Trig.rotate_x(last_rotation) * @acceleration
        @y += Trig.rotate_y(last_rotation) * @acceleration
      else
        @x += Trig.rotate_x(rotation) * @acceleration
        @y += Trig.rotate_y(rotation) * @acceleration
      end

      # reduce acceleration each frame
      @acceleration -= ((self.class.drag + (braking? ? self.class.brakes : 1)) * frame_time)
      @acceleration = @acceleration.clamp(0, self.class.max_acceleration)
    end

    def draw
      super
    end
  end
end
