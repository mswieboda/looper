module Looper
  class HeadsUpDisplay
    PADDING = 15
    TEXT_COLOR = Color::White

    def initialize
      @loops = Text.new(
        text: "loops: 0",
        x: PADDING,
        y: PADDING,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
    end

    def update(frame_time)
    end

    def loops=(value : UInt16)
      @loops.text = "loops: #{value}"
    end

    def draw
      @loops.draw

      if Game.edit_mode?
        Text.new(
          text: "edit mode",
          x: 0,
          y: 0,
          size: 18,
          spacing: 1,
          color: TEXT_COLOR
        ).draw
      end
    end
  end
end
