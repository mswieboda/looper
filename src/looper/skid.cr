require "./vehicle"

module Looper
  class Skid < Game::Line
    getter? expired

    DEFAULT_THICKNESS = 10
    TIME_TO_EXPIRE = 15
    DEFAULT_COLOR_ALPHA = 0.5
    DEFAULT_COLOR = Game::Color::Black.alpha(DEFAULT_COLOR_ALPHA)

    def initialize(end_x, end_y, start_x = 0, start_y = 0, color = DEFAULT_COLOR, thickness = DEFAULT_THICKNESS)
      super(
        end_x: end_x,
        end_y: end_y,
        start_x: start_x,
        start_y: start_y,
        color: color,
        thickness: thickness
      )

      @expired = false
      @expiration = 0_f32
    end

    def update(frame_time)
      return if expired?

      @expiration += frame_time

      if @expiration >= TIME_TO_EXPIRE
        @expired = true
        @expiration = TIME_TO_EXPIRE
      end

      rectangle.color = rectangle.color.alpha(color_alpha)
    end

    def color_alpha
      (DEFAULT_COLOR_ALPHA - @expiration / TIME_TO_EXPIRE).clamp(0.0, 1.0)
    end

    def draw(view_x, view_y)
      super

      draw_line(view_x, view_y, Game::Color::Gray.alpha(color_alpha))
    end
  end
end
