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

      @road_turns << RoadTurn.new(x: 750 + 275, y: 600 - 275, base: 43, degrees: 90, start_degrees: 90)
      @road_turns << RoadTurn.new(x: 750 + 137, y: 600 - 275, base: 43, degrees: 90, start_degrees: 270)

      @roads << Road.new(x: 275, y: 462, width: 475, height: 137)
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
