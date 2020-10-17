require "./vehicle"

module Looper
  class Skid < Game::Line
    getter? expired

    TIME_TO_EXPIRE = 1

    def initialize(end_x, end_y, start_x = 0, start_y = 0, color = nil)
      super(
        end_x: end_x,
        end_y: end_y,
        start_x: start_x,
        start_y: start_y,
        color: color
      )

      @expired = false
      @expiration = 0_f32
    end

    def update(frame_time)
      return if expired?

      @expiration += frame_time

      @expired = true if @expiration >= TIME_TO_EXPIRE
    end

    def draw(view_x, view_y)
      LibRay.draw_line_v(
        start_pos: LibRay::Vector2.new(
          x: view_x + start_x,
          y: view_y + start_y
        ),
        end_pos: LibRay::Vector2.new(
          x: view_x + end_x,
          y: view_y + end_y
        ),
        color: color.to_struct
      )
    end
  end
end
