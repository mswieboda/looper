module Looper
  class Road < Obj
    property color : Game::Color

    def initialize(x, y, width, height, @color = Game::Color::Gray)
      super(
        x: x,
        y: y,
        width: width,
        height: height,
      )
    end

    def draw(view_x, view_y)
      Game::Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height,
        color: color
      ).draw(view_x, view_y)
      super
    end
  end
end
