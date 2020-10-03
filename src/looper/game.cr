module Looper
  class Game < Game
    DEBUG = false
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
      @course.update(frame_time)
      Message.message.update(frame_time)
    end

    def draw
      @course.draw
      Message.message.draw
    end
  end
end
