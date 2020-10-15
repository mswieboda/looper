module Looper
  class Checkpoint < Obj
    getter? show
    getter? passed

    PASSED_HIT_BOX_COLOR = Game::Color::Lime

    def initialize(x, y, width, height, @show = false)
      super(
        x: x,
        y: y,
        width: width,
        height: height
      )

      @passed = false
    end

    def draw(view_x, view_y)
      draw_checker_board(view_x, view_y) if show?
      super(view_x, view_y) if G::DEBUG
    end

    def pass
      @passed = !@passed
      @hit_box_color = passed? ? PASSED_HIT_BOX_COLOR : Obj::HIT_BOX_COLOR
    end

    def reset
      pass if passed?
    end

    def draw_checker_board(view_x, view_y)
      size = 10

      (width / size).to_i.times do |col|
        (height / size).to_i.times do |row|
          Game::Rectangle.new(
            x: x + size * col,
            y: y + size * row,
            width: size,
            height: size,
            color: (col + row) % 2 == 0 ? Game::Color::Black : Game::Color::White
          ).draw(view_x, view_y)
        end
      end
    end
  end
end
