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

      load_sprites

      Message.init

      @menu = Menu.new
      @course = Course.new
      @hud = HeadsUpDisplay.new
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

      if @course.game_over?
        if !Message.shown? && !Message.done?
          Message.show("Game Over!")
        elsif Message.done?
          @course = Course.new
          @menu.show
        end
      end

      Message.message.update(frame_time)

      @hud.loops = @course.loops
    end

    def draw
      if @menu.shown?
        @menu.draw
        return
      end

      @course.draw
      Message.message.draw
      @hud.draw
    end

    def close?
      @menu.exit?
    end
  end
end
