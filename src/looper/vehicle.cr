require "./obj"

module Looper
  abstract class Vehicle < Obj
    getter rotation : Int32 | Float32
    getter speed : Int32 | Float32
    getter acceleration : Int32 | Float32

    getter? offroad
    getter? drifting
    getter? braking
    getter? reverse
    getter? player

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
      @offroad = false
    end

    def self.initial_acceleration
      3
    end

    def self.acceleration
      5
    end

    def self.max_acceleration
      50
    end

    def self.max_speed
      50
    end

    def self.drag
      3
    end

    def self.turning
      130
    end

    def self.drift_turning
      30
    end

    def self.drift_rotation_increase
      30
    end

    def self.drift_braking
      3
    end

    def self.brakes
      15
    end

    def self.offroad_friction
      5
    end

    def self.max_offroad_acceleration
      offroad_friction + drag + initial_acceleration
    end

    def self.offroad_speed_deceleration_factor
      0.15_f32
    end

    def moving?
      @speed > 0
    end

    def accelerate(frame_time)
      return if braking? && !reverse?

      if drifting?
        @acceleration = self.class.initial_acceleration
      else
        @acceleration += self.class.acceleration * frame_time
      end

      @acceleration = @acceleration.clamp(..self.class.max_acceleration)
      @acceleration = @acceleration.clamp(..self.class.max_offroad_acceleration) if offroad?

      @speed += @acceleration * frame_time * (reverse? ? -1 : 1)
    end

    def offroad=(value : Bool)
      @offroad = value
      @acceleration = -@speed * self.class.offroad_speed_deceleration_factor if @offroad
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
      @speed -= self.class.drag * frame_time
      @speed -= self.class.offroad_friction * frame_time if offroad?
      @speed -= self.class.brakes * frame_time if braking?
      @speed -= self.class.drift_braking * frame_time if drifting?
      @speed = @speed.clamp(0, self.class.max_speed)
    end

    def input(frame_time)
      return unless player?

      if Game::Keys.down?([Game::Key::Up, Game::Key::W])
        accelerate(frame_time)
      else
        @acceleration = self.class.initial_acceleration
      end

      turn_left(frame_time) if Game::Keys.down?([Game::Key::Left, Game::Key::A])
      turn_right(frame_time) if Game::Keys.down?([Game::Key::Right, Game::Key::D])

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
