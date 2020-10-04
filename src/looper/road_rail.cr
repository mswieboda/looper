module Looper
  class RoadRail
    THICKNESS = 5

    property v1 : Vector
    property v2 : Vector
    property color : Color

    def initialize(@v1, @v2, @thickness = THICKNESS, @color = Color::Red)
    end

    def draw
      LibRay.draw_line_v(
        start_pos: v1.to_struct,
        end_pos: v2.to_struct,
        color: color.to_struct
      )
    end
  end
end
