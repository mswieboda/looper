module Looper
  class Game < Game
    DEBUG = false
    TARGET_FPS = 60

    def initialize
      super(
        name: "looper",
        target_fps: TARGET_FPS,
        audio: false,
        debug: DEBUG,
        draw_fps: DEBUG
      )
    end

    def update(frame_time)
    end

    def draw
      Rectangle.new(x: 100, y: 100, width: 100, height: 500).draw
    end
  end
end
