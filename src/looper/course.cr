module Looper
  class Course
    GAME_OVER_DELAY = 0.3

    getter loops : UInt16
    getter? game_over_started

    @game_over_delay : Float32

    @tiles : Array(Tile)
    @roads : Array(Road)
    @road_turns : Array(RoadTurn)
    @checkpoints : Array(Checkpoint)

    def initialize
      @game_over_started = false
      @game_over_delay = 0_f32
      @loops = 0_u8

      @tiles = [] of Tile
      @roads = [] of Road
      @road_corners = [] of RoadCorner
      @road_turns = [] of RoadTurn
      @checkpoints = [] of Checkpoint

      # tiles
      tiles_x = (Game.screen_width / Tile::SIZE).to_i
      tiles_y = (Game.screen_height / Tile::SIZE).to_i

      (0..tiles_x).each do |x|
        (0..tiles_y).each do |y|
          @tiles << Grass.new(x: x * Tile::SIZE, y: y * Tile::SIZE)
        end
      end
      # @tiles << Grass.new(x: 300, y: 0)

      # roads / checkpoints
      @roads << Road.new(x: 250, y: 50, width: 600, height: 100)
      @checkpoints << Checkpoint.new(x: 350, y: 25, width: 50, height: 150, show: true)

      @road_corners << RoadCorner.new(x: 850, y: 50, h_size: 2, v_size: 2)
      @road_turns << RoadTurn.new(x: 800, y: 150, h_gap: 1, h_size: 2, v_size: 2, v_gap: 3) #
      @road_corners << RoadCorner.new(x: 850, y: 500, h_size: 2, v_size: 2, v_flip: true)

      @roads << Road.new(x: 250, y: 500, width: 600, height: 100)
      @checkpoints << Checkpoint.new(x: 350, y: 475, width: 50, height: 150)

      @road_corners << RoadCorner.new(x: 150, y: 500, h_size: 2, v_size: 2, h_flip: true, v_flip: true)
      @road_turns << RoadTurn.new(x: 50, y: 150, h_gap: 1, h_size: 2, v_size: 2, v_gap: 3, h_flip: true)
      @road_corners << RoadCorner.new(x: 150, y: 50, h_size: 2, v_size: 2, h_flip: true)

      # player
      @player = Player.new(x: 250, y: 100)
    end

    def update(frame_time)
      return if game_over?

      @game_over_delay += frame_time if game_over_started?

      @player.update(frame_time)

      if @player.collision?(@roads) || @road_corners.any?(&.collision?(@player.car)) || @road_turns.any?(&.collision?(@player.car))
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
      @tiles.each(&.draw)
      @roads.each(&.draw)
      @road_corners.each(&.draw)
      @road_turns.each(&.draw)
      @checkpoints.each(&.draw)
      @player.draw
    end

    def game_over?
      @game_over_delay >= GAME_OVER_DELAY
    end
  end
end
