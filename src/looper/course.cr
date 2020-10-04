module Looper
  class Course
    GAME_OVER_DELAY = 0.3

    getter loops : UInt16
    getter? game_over_started

    @game_over_delay : Float32
    @roads : Array(Road)
    @road_turns : Array(RoadTurn)
    @checkpoints : Array(Checkpoint)

    def initialize
      @roads = [
        Road.new(x: 100, y: 50, width: 650, height: 100),
        Road.new(x: 100, y: 500, width: 650, height: 100),
      ]

      @road_turns = [
        RoadTurn.new(x: 750, y: 150, h_gap: 2, h_size: 2, v_size: 2, v_gap: 3)
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
      @road_turns.each(&.draw)
      @checkpoints.each(&.draw) if Game::DEBUG
      @player.draw
    end

    def game_over?
      @game_over_delay >= GAME_OVER_DELAY
    end
  end
end
