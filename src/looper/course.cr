module Looper
  class Course
    GAME_OVER_DELAY = 0.3

    getter loops : UInt16
    getter? game_over_started

    @game_over_delay : Float32

    @tiles : Array(Tile)
    @rivers : Array(River)
    @roads : Array(Road)
    @road_turns : Array(RoadTurn)
    @checkpoints : Array(Checkpoint)

    def initialize
      @game_over_started = false
      @game_over_delay = 0_f32
      @loops = 0_u8

      @rivers = [] of River
      @tiles = [] of Tile
      @roads = [] of Road
      @road_corners = [] of RoadCorner
      @road_turns = [] of RoadTurn
      @checkpoints = [] of Checkpoint

      tiles_x = (Game.screen_width / Tile::SIZE).to_i
      tiles_y = (Game.screen_height / Tile::SIZE).to_i

      # rivers
      rivers_y = 300
      (0..tiles_x).each do |x|
        @rivers << River.new(x: x * Tile::SIZE, y: rivers_y)
      end

      # tiles
      (0..tiles_x).each do |x|
        (0..tiles_y).each do |y|
          next if @rivers.any? { |r| r.x == x && r.y == y }
          @tiles << Grass.new(x: x * Tile::SIZE, y: y * Tile::SIZE)
        end
      end


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
      @player = Player.new(x: 250, y: 100, vehicle_class: Motorcycle)
    end

    def update(frame_time)
      return if game_over?

      @game_over_delay += frame_time if game_over_started?

      @rivers.each(&.update(frame_time))
      @player.update(frame_time)

      if road_collision?
        @player.input(frame_time)
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
      @rivers.each(&.draw)
      @roads.each(&.draw)
      @road_corners.each(&.draw)
      @road_turns.each(&.draw)
      @checkpoints.each(&.draw)
      @player.draw
    end

    def road_collision?
      @player.collision?(@roads) ||
        @road_corners.any?(&.collision?(@player.vehicle)) ||
        @road_turns.any?(&.collision?(@player.vehicle))
    end

    def game_over?
      @game_over_delay >= GAME_OVER_DELAY
    end

    def difficulty=(difficulty)
      @player.difficulty = difficulty
    end
  end
end
