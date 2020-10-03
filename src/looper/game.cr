module Looper
  class Game < Game
    DEBUG = true
    TARGET_FPS = 60

    def initialize
      super(
        name: "looper",
        screen_width: 1080,
        screen_height: 640,
        target_fps: TARGET_FPS,
        audio: false,
        debug: DEBUG,
        draw_fps: DEBUG
      )

      load_sprites

      Message.init

      @menu = Menu.new
      @course = Course.new
    end

    def load_sprites
      Sprite.load({
        :car => {
          filename: "../assets/car.png",
          width: 56,
          height: 24,
          loops: false,
        },
      })
    end

    def update(frame_time)
      if @menu.shown?
        @menu.update(frame_time)
        return
      end

      @course.update(frame_time)
      Message.message.update(frame_time)

      if @course.game_over?
        if !Message.shown?
          Message.show("Game Over!")
        elsif Message.done?
          @menu.show
        end
      end
    end

    def draw
      if @menu.shown?
        @menu.draw
        return
      end

      @course.draw
      Message.message.draw
    end

    def close?
      @menu.exit?
    end
  end
end
