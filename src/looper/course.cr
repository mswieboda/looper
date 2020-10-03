module Looper
  class Course
    @roads : Array(Road)

    def initialize
      @roads = [
        Road.new(x: 50, y: 50, width: 500, height: 100),
        Road.new(x: 150, y: 150, width: 100, height: 500)
      ]

      @player = Player.new(x: 50, y: 50)
    end

    def update(frame_time)
      @roads.each(&.update(frame_time))
      @player.update(frame_time, @roads)
    end

    def draw
      @roads.each(&.draw)
      @player.draw
    end
  end
end