require "./vehicle"

module Looper
  class Skid
    getter x : Int32 | Float32
    getter y : Int32 | Float32
    getter rotation : Int32 | Float32

    def initialize(@x, @y, @rotation)
    end

    def update(frame_time)
    end

    def draw(view_x, view_y)
    end
  end
end
