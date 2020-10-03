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

      @course = Course.new
    end

    def update(frame_time)
      @course.update(frame_time)
    end

    def draw
      @course.draw
    end
  end
end
