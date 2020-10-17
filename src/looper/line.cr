require "./vehicle"

module Looper
  class Line
    getter start_x : Int32 | Float32
    getter start_y : Int32 | Float32
    getter end_x : Int32 | Float32
    getter end_y : Int32 | Float32
    property color : Game::Color
    getter thickness : Int32 | Float32

    @rectangle : Game::Rectangle?

    DEFAULT_THICKNESS = 10

    def initialize(@end_x, @end_y, @start_x = 0, @start_y = 0, @color = Game::Color::Red, @thickness = DEFAULT_THICKNESS)
      @rectangle = nil
    end

    # setters
    {% for name in [:start_x, :start_y, :end_x, :end_y, :color, :thickness] %}
      def {{name.id}}=(value : Int32 | Float32)
        @{{name.id}} = value
        @rectangle = nil
      end
    {% end %}

    def color=(value : Game::Color)
      @color = value
      rectangle.color = value
    end

    def rectangle
      if rectangle = @rectangle
        return rectangle
      end

      p1x = [start_x, end_x].min
      p1y = p1x == start_x ? start_y : end_y

      p2x = p1x == start_x ? end_x : start_x
      p2y = p1y == start_y ? end_y : start_y

      dx = p2x - p1x
      dy = p2y - p1y
      theta = Trig.to_degrees(Math.atan(dx / dy))

      radius = @thickness / 2

      x = p1x + Trig.rotate_x(radius, theta) + (dy.sign < 0 ? dx : 0)
      y = p1y - Trig.rotate_y(radius, theta) + (dy.sign < 0 ? dy : 0)

      width = Math.sqrt(dx ** 2 + dy ** 2)

      rectangle = Game::Rectangle.new(
        x: x.to_f32,
        y: y.to_f32,
        width: width.to_f32,
        height: @thickness,
        rotation: (90 - theta).to_f32,
        color: color,
      )

      @rectangle = rectangle

      rectangle
    end

    def draw(view_x, view_y)
      thickness > 1 ? rectangle.draw(view_x, view_y) : draw_line(view_x, view_y)
    end

    def draw_line(view_x, view_y, color = @color)
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
