require "./vehicle"

module Looper
  class Skid < Game::Line
    def initialize(end_x, end_y, start_x = 0, start_y = 0, color = nil)
      super(
        end_x: end_x,
        end_y: end_y,
        start_x: start_x,
        start_y: start_y,
        color: color
      )
    end

    def update(frame_time)
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
