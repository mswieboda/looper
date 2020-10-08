module Looper
  class RoadTurn
    @traps : Array(Trapezoid)

    def initialize(x, y, height, degrees = 180, segments = 10, color = Color::Gray)
      @traps = [] of Trapezoid
      traps = [] of NamedTuple(x: Int32 | Float32 | Float64, y: Int32 | Float32 | Float64, rotation: Int32 | Float32 | Float64)

      rotation_amount = 180 / segments
      angle = (180 - rotation_amount) / 2
      last_rotation = 90 - angle
      new_x = 0
      new_y = 0

      trap = {
        x: 0,
        y: 0,
        rotation: last_rotation
      }
      traps << trap

      height_segments = ([degrees, 180].min / 180 * segments - 1).round.to_i
      base = height / (height_segments + 1).times.map { |n| Trig.rotate_y(2, last_rotation + n * rotation_amount) }.sum

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
        puts "#{trap}"
        @traps << Trapezoid.new(
          x: x + trap[:x].to_f32,
          y: y - trap[:y].to_f32,
          angle: angle.to_f32,
          rotation: trap[:rotation].to_f32,
          base: base.to_f32,
          color: Game::DEBUG ? Color.random : color
        )
      end
    end

    def collision?(obj : Obj)
      obj.collision?(@traps)
    end

    def draw
      @traps.each(&.draw)
    end
  end
end
