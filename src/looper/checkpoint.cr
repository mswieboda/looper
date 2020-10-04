module Looper
  class Checkpoint < Obj
    getter? show
    getter? passed

    PASSED_HIT_BOX_COLOR = Color::Lime

    def initialize(x, y, width, height, @show = false)
      super(
        x: x,
        y: y,
        width: width,
        height: height
      )

      @passed = false
    end

    def draw
      draw_checker_board if show?
      super if Game::DEBUG
    end

    def pass
      @passed = !@passed
      @hit_box_color = passed? ? PASSED_HIT_BOX_COLOR : Obj::HIT_BOX_COLOR
    end

    def reset
      pass if passed?
    end

    def draw_checker_board
      size = 10

      (width / size).to_i.times do |col|
        (height / size).to_i.times do |row|
          Rectangle.new(
            x: x + size * col,
            y: y + size * row,
            width: size,
            height: size,
            color: (col + row) % 2 == 0 ? Color::Black : Color::White
          ).draw
        end
      end
    end
  end
end
