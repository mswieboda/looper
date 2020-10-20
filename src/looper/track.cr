module Looper
  abstract class Track
    GAME_OVER_DELAY = 0.3

    getter? game_over_started
    property? paused
    getter laps : UInt16
    getter lap_time : Float32
    getter lap_times : Array(Float32)

    delegate :exit?, to: @menu
    delegate :speed, to: @player

    @game_over_delay : Float32

    @player : Player

    @tiles : Array(Tile)
    @rivers : Array(River)
    @roads : Array(Road)
    @road_turns : Array(RoadTurn)
    @checkpoints : Array(Checkpoint)

    @difficulty : String
    @menu : PauseMenu

    def initialize(@difficulty = "")
      @game_over_started = false
      @game_over_delay = 0_f32
      @paused = true
      @laps = 0_u8
      @lap_timer_paused = true
      @lap_time = 0_f32
      @lap_times = [] of Float32

      @rivers = [] of River
      @tiles = [] of Tile
      @roads = [] of Road
      @road_turns = [] of RoadTurn
      @checkpoints = [] of Checkpoint

      # player
      @player = Player.new(difficulty: @difficulty)

      # view
      @view = View.new

      # menu
      @menu = PauseMenu.new
    end

    def restart
      @game_over_started = false
      @game_over_delay = 0_f32
      @laps = 0_u8
      @lap_timer_paused = true
      lap_times.clear

      @player = Player.new(x: 250, y: 100, difficulty: @difficulty)
    end

    def update(frame_time)
      @rivers.each(&.update(frame_time))

      return if game_over?

      if @menu.shown?
        @menu.update(frame_time)

        if @menu.resume?
          unpause
        elsif @menu.restart?
          restart
          unpause
        elsif @menu.difficulty?
          change_difficulty(@menu.difficulty)
          restart
          unpause
        end

        return
      end

      return if paused?

      @lap_time += frame_time unless @lap_timer_paused # @lap_timer.get.to_f32 - @lap_time

      @game_over_delay += frame_time if game_over_started?

      @player.update(frame_time)
      @view.update(frame_time, @player)

      if G.edit_mode?
        @roads.each(&.update(frame_time, @view.view_x, @view.view_y))
        @road_turns.each(&.update(frame_time, @view.view_x, @view.view_y))
        @checkpoints.each(&.update(frame_time, @view.view_x, @view.view_y))
        return
      end

      # road
      if road_collision?
        @player.input(frame_time)
      else
        @game_over_started = true
      end

      # checkpoints
      if @player.collision?(@checkpoints.first)
        @checkpoints.first.pass

        if @checkpoints.all?(&.passed?)
          # lap passed
          lap_times << @lap_time
          restart_lap_timer

          @laps += 1
          @checkpoints.each(&.reset)
        elsif @checkpoints[1..-1].none?(&.passed?)
          # first starting lap
          restart_lap_timer
        end
      else
        # mark passed checkpoints as passed
        @checkpoints.reject(&.passed?).select { |c| @player.collision?(c) }.each(&.pass)
      end

      # pause menu
      pause if Game::Keys.pressed?([Game::Key::Escape, Game::Key::Space, Game::Key::Backspace])
    end

    def pause
      @paused = true
      @lap_timer_paused = true
      @menu.show
    end

    def unpause
      @paused = false
      @lap_timer_paused = false
      @menu.hide
    end

    def restart_lap_timer
      @lap_time = 0_f32
      @lap_timer_paused = false
    end

    def draw
      view_x = @view.view_x
      view_y = @view.view_y

      @tiles.each(&.draw(view_x, view_y))
      @rivers.each(&.draw(view_x, view_y))
      @roads.each(&.draw(view_x, view_y))
      @road_turns.each(&.draw(view_x, view_y))
      @checkpoints.each(&.draw(view_x, view_y))
      @player.draw(view_x, view_y)
      @menu.draw # TODO: move out of track?
    end

    def road_collision?
      @player.collision?(@roads) ||
        @road_turns.any?(&.collision?(@player.vehicle))
    end

    def game_over?
      @game_over_delay >= GAME_OVER_DELAY
    end

    def difficulty=(difficulty)
      change_difficulty(difficulty)
    end

    def change_difficulty(difficulty)
      @difficulty = difficulty
      @player.difficulty = difficulty
    end
  end
end
