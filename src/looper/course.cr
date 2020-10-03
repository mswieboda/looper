module Looper
  class Course
    def initialize
      @road = Road.new(
        x: 50,
        y: 50,
        width: 500,
        height: 100
      )

      @player = Player.new(
        x: 55,
        y: 55
      )
    end

    def update(frame_time)
      @road.update(frame_time)
      @player.update(frame_time)
    end

    def draw
      @road.draw
      @player.draw
    end
  end
end