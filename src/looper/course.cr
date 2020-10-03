module Looper
  class Course
    getter? game_over

    @roads : Array(Road)

    def initialize
      @roads = [
        Road.new(x: 100, y: 50, width: 750, height: 100),
        Road.new(x: 750, y: 100, width: 100, height: 100),
        Road.new(x: 800, y: 100, width: 100, height: 450),
        Road.new(x: 750, y: 450, width: 100, height: 100),
        Road.new(x: 100, y: 500, width: 750, height: 100),
        Road.new(x: 100, y: 450, width: 100, height: 100),
        Road.new(x: 50, y: 100, width: 100, height: 450),
        Road.new(x: 100, y: 100, width: 100, height: 100),
      ]

      @player = Player.new(x: 250, y: 100)
    end

    def update(frame_time)
      return if game_over?

      @roads.each(&.update(frame_time))
      @player.update(frame_time)

      if @player.collision?(@roads)
        @player.movement(frame_time)
      else
        @game_over = true
        Message.show("Game Over!")
      end
    end

    def draw
      @roads.each(&.draw)
      @player.draw
    end
  end
end