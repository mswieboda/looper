module Looper
  abstract class Obj
    property x : Int32 | Float32
    property y : Int32 | Float32
    property width : Int32
    property height : Int32
    property color : Color

    def initialize(@x, @y, @width, @height, @color)
    end

    def update(frame_time)
    end

    def draw
    end
  end
end
