require "./obj"

module Looper
  abstract class Vehicle < Obj
    getter rotation : Int32 | Float32
    getter? drifting
    getter? braking
    getter? reverse
    getter? player

    @speed : Int32 | Float32
    @acceleration : Int32 | Float32
    @last_rotation : Int32 | Float32

    def initialize(x, y, width, height, @player = false)
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
      @reverse = false
    end

    def self.initial_acceleration
      5
    end

    def self.acceleration
      15
    end

    def self.max_speed
      50
    end

    def self.drag
      10
    end

    def self.turning
      130
    end

    def self.drift_turning
      15
    end

    def self.drift_rotation_increase
      5
    end

    def moving?
      @speed > 0
    end

    def accelerate(frame_time)
      return if braking? && !reverse?

      @acceleration += self.class.acceleration * frame_time

      @speed += @acceleration * frame_time * (reverse? ? -1 : 1)
    end

    def turn_left(frame_time)
      turn(-frame_time)
    end

    def turn_right(frame_time)
      turn(frame_time)
    end

    def turn(time_and_direction)
      return unless moving?

      @rotation += (self.class.turning + (drifting? ? self.class.drift_turning : 0)) * time_and_direction
    end

    def update(frame_time)
      movement(frame_time)
    end

    def movement(frame_time)
      return unless moving?

      # extra rotation used for drifting
      @last_rotation += (rotation - @last_rotation) * self.class.drift_rotation_increase * frame_time

      angle = drifting? ? @last_rotation : rotation

      @x += Trig.rotate_x(@speed, angle).to_f32
      @y += Trig.rotate_y(@speed, angle).to_f32

      # reduce speed each frame
      @speed -= ((self.class.drag + (braking? ? self.class.brakes : 1)) * frame_time)
      @speed = @speed.clamp(0, self.class.max_speed)
    end

    def input(frame_time)
      return unless player?

      if Game::Keys.down?([Game::Key::Up, Game::Key::W])
        accelerate(frame_time)
      else
        @acceleration = self.class.initial_acceleration
      end

      if Game::Keys.down?([Game::Key::Left, Game::Key::A])
        turn_left(frame_time)
      end

      if Game::Keys.down?([Game::Key::Right, Game::Key::D])
        turn_right(frame_time)
      end

      if Game::Keys.pressed?([Game::Key::LShift, Game::Key::RShift])
        @drifting = true
      elsif Game::Keys.released?([Game::Key::LShift, Game::Key::RShift])
        @drifting = false
      end

      if Game::Keys.pressed?([Game::Key::Down, Game::Key::S])
        @braking = true
      elsif Game::Keys.released?([Game::Key::Down, Game::Key::S])
        @braking = false
      end
    end

    def draw(view_x, view_y)
      super(view_x, view_y)
    end
  end
end
