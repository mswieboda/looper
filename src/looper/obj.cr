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

    def hit_box
      Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height,
        color: Color::Red,
        filled: false
      )
    end

    def collision?(objs : Array(Obj))
      objs.any? { |obj| collision?(obj) }
    end

    def collision?(obj : Obj)
      collision?(obj.hit_box.x, obj.hit_box.y, obj.hit_box.width, obj.hit_box.height)
    end

    def collision?(x, y, width, height)
      hit_box.x < x + width &&
        hit_box.x + hit_box.width > x &&
        hit_box.y < y + height &&
        hit_box.y + hit_box.height > y
    end
  end
end
