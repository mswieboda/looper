require "./editable"

module Looper
  abstract class Obj
    include Editable

    property x : Int32 | Float32
    property y : Int32 | Float32
    property width : Int32
    property height : Int32

    HIT_BOX_COLOR = Color::Red

    @hit_box_color : Color

    def initialize(@x, @y, @width, @height, @hit_box_color = HIT_BOX_COLOR)
    end

    def draw(view_x, view_y)
      hit_box.draw(view_x, view_y) if Game::DEBUG
    end

    def hit_box
      Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height,
        color: selected? ? SELECTED_HIT_BOX_COLOR : @hit_box_color,
        filled: false
      )
    end

    def collision?(objs : Array(Obj))
      objs.any? { |obj| collision?(obj) }
    end

    def collision?(rects : Array(Rectangle))
      rects.any? { |rect| collision?(rect) }
    end

    def collision?(tris : Array(Triangle))
      tris.any? { |tri| collision?(tri) }
    end

    def collision?(traps : Array(Trapezoid))
      traps.any? { |trap| trap.collision?(self) }
    end

    def collision?(obj : Obj)
      collision?(x: obj.hit_box.x, y: obj.hit_box.y, width: obj.hit_box.width, height: obj.hit_box.height)
    end

    def collision?(rect : Rectangle)
      collision?(x: rect.x, y: rect.y, width: rect.width, height: rect.height)
    end

    def collision?(x, y, width, height)
      hit_box.x <= x + width &&
        hit_box.x + hit_box.width >= x &&
        hit_box.y <= y + height &&
        hit_box.y + hit_box.height >= y
    end

    def collision?(v : Vector)
      collision?(v.x, v.y)
    end

    def collision?(x, y)
      hit_box.x <= x &&
        hit_box.x + hit_box.width >= x &&
        hit_box.y <= y &&
        hit_box.y + hit_box.height >= y
    end

    def collision?(tri : Triangle)
      tri_points = [
        Vector.new(x: tri.x1, y: tri.y1),
        Vector.new(x: tri.x2, y: tri.y2),
        Vector.new(x: tri.x3, y: tri.y3)
      ]

      return true if tri_points.all? { |v| collision?(v) }

      obj_points = [
        Vector.new(hit_box.x, hit_box.y),
        Vector.new(hit_box.x + hit_box.width, hit_box.y),
        Vector.new(hit_box.x + hit_box.width, hit_box.y + hit_box.height),
        Vector.new(hit_box.x, hit_box.y + hit_box.height)
      ]

      # check if any obj points are inside triangle
      return true if obj_points.any?(&.collision?(tri))

      obj_lines = [] of Array(Vector)
      tri_lines = [] of Array(Vector)

      obj_lines << [obj_points[0], obj_points[1]]
      obj_lines << [obj_points[1], obj_points[2]]
      obj_lines << [obj_points[2], obj_points[3]]
      obj_lines << [obj_points[3], obj_points[0]]

      tri_lines << [tri_points[0], tri_points[1]]
      tri_lines << [tri_points[1], tri_points[2]]
      tri_lines << [tri_points[2], tri_points[0]]

      # check if any obj lines intersect triangle lines
      obj_lines.each do |obj_line|
        tri_lines.each do |tri_line|
          return true if Vector.collision?(a1: obj_line[0], a2: obj_line[1], b1: tri_line[0], b2: tri_line[1])
        end
      end

      false
    end
  end
end
