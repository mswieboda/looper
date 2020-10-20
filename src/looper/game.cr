module Looper
  class G < Game::Game
    DEBUG = false
    TARGET_FPS = 60

    @@edit_mode = false

    def self.edit_mode?
      @@edit_mode
    end

    def initialize
      super(
        name: "looper",
        screen_width: 1024,
        screen_height: 640,
        target_fps: TARGET_FPS,
        audio: false,
        debug: DEBUG,
        draw_fps: DEBUG
      )

      # don't exit with ESC key
      LibRay.set_exit_key(-1)

      load_sprites

      Message.init

      @menu = MainMenu.new
      @track = Tracks::Loop.new
      @hud = HeadsUpDisplay.new

      @menu.show
    end

    def load_sprites
      Game::Sprite.load({
        :car => {
          filename: "../assets/car.png",
          width: 56,
          height: 24,
          loops: false,
        },
        :motorcycle => {
          filename: "../assets/motorcycle.png",
          width: 56,
          height: 24,
          loops: false,
        },
        :grass_accents => {
          filename: "../assets/grass_accents.png",
          width: 8,
          height: 8,
          loops: false,
        },
        :river_accents => {
          filename: "../assets/river_accents.png",
          width: 8,
          height: 8,
          loops: true,
        }
      })
    end

    def update(frame_time)
      @track.update(frame_time)

      if DEBUG && Game::Key::F3.pressed?
        @@edit_mode = !@@edit_mode
      end

      if @menu.shown?
        @track.paused = true
        @menu.update(frame_time)

        if @menu.done?
          @track.difficulty = @menu.difficulty
          @track.paused = false
          @menu.hide
        end

        return
      end

      if @track.game_over?
        if !Message.shown? && !Message.done?
          Message.show("Game Over!")
        elsif Message.done?
          @track = Tracks::Loop.new(difficulty: @menu.difficulty)
          @menu.show
        end
      end

      Message.message.update(frame_time)

      @hud.laps = @track.laps
      @hud.lap_time = @track.lap_time
      @hud.lap_times = @track.lap_times
      @hud.speed = @track.speed
    end

    def draw
      @track.draw

      if @menu.shown?
        @menu.draw
        return
      end

      Message.message.draw
      @hud.draw
    end

    def close?
      @menu.exit? || @track.exit?
    end
  end
end
