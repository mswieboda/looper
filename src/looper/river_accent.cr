module Looper
  class RiverAccent < Accent
    DELAY = 5_f32

    def initialize(x, y)
      super(x: x, y: y, sprite: Sprite.get(:river_accents))
      @sprite.frame = @sprite.frames - 1
      @sprite.pause
      @delay = rand(DELAY).to_f32
    end

    def update(frame_time)
      @sprite.update(frame_time)

      if @sprite.paused? && @delay < DELAY
        @delay += frame_time
      elsif @delay >= DELAY
        @delay = 0_f32
        @sprite.start
      elsif @sprite.done?
        @sprite.pause
        @delay = rand(DELAY).to_f32
      end
    end
  end
end
