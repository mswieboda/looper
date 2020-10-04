module Looper
  class Road < Obj
    property color : Color

    def initialize(x, y, width, height, @color = Color::Gray)
      super(
        x: x,
        y: y,
        width: width,
        height: height,
      )
    end

    def draw
      Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height,
        color: color
      ).draw
    end
  end
end