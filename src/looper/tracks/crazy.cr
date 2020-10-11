module Looper::Tracks
  class Crazy < Track

    def initialize(difficulty = "")
      super(difficulty: difficulty)

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
      @roads << Road.new(x: 275, y: 50, width: 475, height: 137)
      @checkpoints << Checkpoint.new(x: 350, y: 45, width: 50, height: 150, show: true)

      @road_turns << RoadTurn.new(x: 750 + 273, y: 325, base: 43, degrees: 90, start_degrees: 90)
      @road_turns << RoadTurn.new(x: 750 + 135, y: 325, base: 43, degrees: 90, start_degrees: 270)

      @roads << Road.new(x: 1155, y: 463, width: 480, height: 137)

      @road_turns << RoadTurn.new(x: 1630, y: 600, base: 43, degrees: 90, start_degrees: 0)
      @road_turns << RoadTurn.new(x: 2318, y: 327, base: 43, start_degrees: 90)

      @roads << Road.new(x: 2181, y: 325, width: 137, height: 203)

      @road_turns << RoadTurn.new(x: 2043, y: 800, base: 43, degrees: 90, start_degrees: 0)

      @roads << Road.new(x: 890, y: 663, width: 1156, height: 137)

      @road_turns << RoadTurn.new(x: 618, y: 525, base: 43, degrees: 90, start_degrees: 270)
      @road_turns << RoadTurn.new(x: 859, y: 738, base: 43, degrees: 90, start_degrees: 90)

      @roads << Road.new(x: 273, y: 463, width: 315, height: 137)
      @checkpoints << Checkpoint.new(x: 350, y: 455, width: 50, height: 150)

      @road_turns << RoadTurn.new(x: 275, y: 50, base: 43, start_degrees: 180)

      # player
      @player = Player.new(difficulty: @difficulty)

      # menu
      @menu = PauseMenu.new

      restart
    end
  end
end
