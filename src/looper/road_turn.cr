module Looper
  class RoadTurn
    include Editable

    getter x : Int32 | Float32
    getter y : Int32 | Float32
    getter base : Int32 | Float32
    getter degrees : Int32 | Float32
    getter start_degrees : Int32 | Float32
    getter segments : Int32
    getter color : Color

    SELECTED_COLOR = Color::Blue

    @traps : Array(Trapezoid)
    @edges : Array(Rectangle)

    def initialize(@x, @y, @base = 30, @degrees = 180, @start_degrees = 0, @segments = 10, @color = Color::Gray)
      @traps = [] of Trapezoid
      @edges = [] of Rectangle
    end

    def traps : Array(Trapezoid)
      unless @traps.empty?
        # memoized
        # if we need to recalculate then set `@traps.clear`
        return @traps
      end

      traps = [] of NamedTuple(x: Int32 | Float32 | Float64, y: Int32 | Float32 | Float64, rotation: Int32 | Float32 | Float64)
      rotation_amount = 180 / segments
      angle = (180 - rotation_amount) / 2
      last_rotation = start_degrees + (90 - angle)
      new_x = 0
      new_y = 0

      trap = {
        x: 0,
        y: 0,
        rotation: last_rotation
      }
      traps << trap

      # TODO: work on base calc with start_degrees
      # height_segments = ([degrees, 180].min / 180 * segments - 1).round.to_i
      # base = height / (height_segments + 1).times.map { |n| Trig.rotate_y(2, last_rotation + n * rotation_amount) }.sum

      (degrees / 180 * segments - 1).round.to_i.times do |n|
        trap = {
          x: new_x + Trig.rotate_x(base * 2, last_rotation),
          y: new_y + Trig.rotate_y(base * 2, last_rotation),
          rotation: last_rotation + rotation_amount
        }

        traps << trap

        new_x = trap[:x]
        new_y = trap[:y]
        last_rotation += rotation_amount
      end

      traps.each do |trap|
        @traps << Trapezoid.new(
          x: x + trap[:x].to_f32,
          y: y - trap[:y].to_f32,
          angle: angle.to_f32,
          rotation: trap[:rotation].to_f32,
          base: base.to_f32,
          color: Game::DEBUG ? Color.random : color
        )

        @edges << Rectangle.new(
          x: x + trap[:x].to_f32,
          y: y - trap[:y].to_f32,
          rotation: -trap[:rotation].to_f32,
          width: (base * 2_f32).to_f32,
          height: 30,
          color: Color::Red
        )
      end

      @traps
    end

    def editable_movement
      @traps.clear
      @edges.clear
    end

    def collision?(obj : Obj)
      obj.collision?(traps)
    end

    def collision?(v : Vector)
      traps.any? { |trap| trap.tris.any? { |tri| v.collision?(tri) } }
    end

    def draw(view_x, view_y)
      traps.each(&.draw(view_x, view_y))
      @edges.each(&.draw(view_x, view_y))

      if selected?
        Circle.new(
          center_x: view_x + x,
          center_y: view_y + y,
          radius: 10,
          color: SELECTED_COLOR,
          filled: false
        ).draw
      end
    end
  end
end
