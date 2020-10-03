module Looper
  class Course
    GAME_OVER_DELAY = 0.3

    getter loops : UInt16
    getter? game_over_started

    @game_over_delay : Float32
    @roads : Array(Road)
    @checkpoints : Array(Checkpoint)

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

      @checkpoints = [
        Checkpoint.new(x: 300, y: 25, width: 50, height: 150),
        Checkpoint.new(x: 300, y: 475, width: 50, height: 150),
      ]

      @player = Player.new(x: 250, y: 100)
      @game_over_started = false
      @game_over_delay = 0_f32
      @loops = 0_u8
    end

    def update(frame_time)
      return if game_over?

      @game_over_delay += frame_time if game_over_started?

      @roads.each(&.update(frame_time))
      @player.update(frame_time)

      if @player.collision?(@roads)
        @player.movement(frame_time)
      else
        @game_over_started = true
      end

      if @checkpoints.all?(&.passed?) && @player.collision?(@checkpoints.first)
        @loops += 1
        @checkpoints.each(&.reset)
      else
        @checkpoints.reject(&.passed?).select { |c| @player.collision?(c) }.each(&.pass)
      end
    end

    def draw
      @roads.each(&.draw)
      @checkpoints.each(&.draw) if Game::DEBUG
      @player.draw
    end

    def game_over?
      @game_over_delay >= GAME_OVER_DELAY
    end
  end
end
