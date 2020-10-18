require "./vehicle"

module Looper
  class Car < Vehicle
    @sprite : Game::Sprite

    alias SkidInfo = NamedTuple(rotation: Int32 | Float32 | Float64, radius: Int32 | Float32 | Float64)

    TIRE_WIDTH = 10

    # skids
    @skids : Array(Skid)
    @skid_info : NamedTuple(back_left: SkidInfo, back_right: SkidInfo)
    @last_skid : NamedTuple(back_left: Game::Vector, back_right: Game::Vector)?

    def initialize(x, y, player = false)
      super(
        x: x,
        y: y,
        width: 56,
        height: 24,
        player: player,
      )

      @sprite = Game::Sprite.get(:car)
      @skids = [] of Skid

      # set up skid tire locations
      adjacent = -(width - 16) / 2
      opposite = height / 2
      radius = Math.sqrt(adjacent ** 2 + opposite ** 2)

      @skid_info = {
        back_left: {
          rotation: Trig.to_degrees(Math.atan(opposite / -adjacent)),
          radius: -radius
        },
        back_right: {
          rotation: Trig.to_degrees(Math.atan(opposite / adjacent)),
          radius: -radius
        }
      }

      @last_skid = {
        back_left: Game::Vector.new,
        back_right: Game::Vector.new
      }
    end

    def self.initial_acceleration
      10
    end

    def self.acceleration
      17
    end

    def self.turning
      130
    end

    def self.drift_turning
      30
    end

    def self.drift_rotation_increase
      3
    end

    def self.brakes
      10
    end

    def update(frame_time)
      super(frame_time)

      @skids.each(&.update(frame_time))
      @skids.reject!(&.expired?)

      if moving? && drifting?
        mid_tire = TIRE_WIDTH / 2

        back_left_x = x + Trig.rotate_x(@skid_info[:back_left][:radius], rotation + @skid_info[:back_left][:rotation])
        back_left_y = y + Trig.rotate_y(@skid_info[:back_left][:radius], rotation + @skid_info[:back_left][:rotation])
        back_left_mid_tire_x = back_left_x - mid_tire * Math.sin(Trig.to_radians(rotation))
        back_left_mid_tire_y = back_left_y + mid_tire * Math.cos(Trig.to_radians(rotation))

        back_right_x = x + Trig.rotate_x(@skid_info[:back_right][:radius], rotation + @skid_info[:back_right][:rotation])
        back_right_y = y + Trig.rotate_y(@skid_info[:back_right][:radius], rotation + @skid_info[:back_right][:rotation])
        back_right_mid_tire_x = back_right_x + mid_tire * Math.sin(Trig.to_radians(rotation))
        back_right_mid_tire_y = back_right_y - mid_tire * Math.cos(Trig.to_radians(rotation))

        skid = {
          back_left: Game::Vector.new(
            x: back_left_mid_tire_x.to_f32,
            y: back_left_mid_tire_y.to_f32
          ),
          back_right: Game::Vector.new(
            x: back_right_mid_tire_x.to_f32,
            y: back_right_mid_tire_y.to_f32
          )
        }

        if last_skid = @last_skid
          # create skids
          @skids << Skid.new(
            end_x: skid[:back_left].x,
            end_y: skid[:back_left].y,
            start_x: last_skid[:back_left].x,
            start_y: last_skid[:back_left].y,
            thickness: TIRE_WIDTH
          )
          @skids << Skid.new(
            end_x: skid[:back_right].x,
            end_y: skid[:back_right].y,
            start_x: last_skid[:back_right].x,
            start_y: last_skid[:back_right].y,
            thickness: TIRE_WIDTH
          )
        end

        @last_skid = skid
      else
        @last_skid = nil
      end
    end

    def draw(view_x, view_y)
      @skids.each(&.draw(view_x, view_y))

      @sprite.draw(
        x: view_x + x,
        y: view_y + y,
        centered: true,
        rotation: rotation
      )

      super(view_x, view_y)
    end

    def hit_box
      max = [width, height].max / 2_f32

      Game::Rectangle.new(
        x: x - max / 2_f32,
        y: y - max / 2_f32,
        width: max,
        height: max,
        color: Game::Color::Red,
        filled: false
      )
    end
  end
end
