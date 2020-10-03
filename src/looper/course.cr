module Looper
  class Course
    def initialize
      @road = Road.new(
        x: 50,
        y: 50,
        width: 500,
        height: 100
      )
    end

    def update(frame_time)
      @road.update(frame_time)
    end

    def draw
      @road.draw
    end
  end
end