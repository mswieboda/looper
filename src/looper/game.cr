module Looper
  class Game < Game
    DEBUG = false
    TARGET_FPS = 60

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
      @course = Course.new
      @hud = HeadsUpDisplay.new

      @menu.show
    end

    def load_sprites
      Sprite.load({
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
      @course.update(frame_time)

      if @menu.shown?
        @course.paused = true
        @menu.update(frame_time)

        if @menu.done?
          @course.difficulty = @menu.difficulty
          @course.paused = false
          @menu.hide
        end

        return
      end

      if @course.game_over?
        if !Message.shown? && !Message.done?
          Message.show("Game Over!")
        elsif Message.done?
          @course = Course.new(difficulty: @menu.difficulty)
          @menu.show
        end
      end

      Message.message.update(frame_time)

      @hud.loops = @course.loops
    end

    def draw
      @course.draw

      if @menu.shown?
        @menu.draw
        return
      end

      Message.message.draw
      @hud.draw
    end

    def close?
      @menu.exit? || @course.exit?
    end
  end
end
