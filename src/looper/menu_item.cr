module Looper
  class MenuItem
    PADDING = 25

    getter? focused

    delegate :text, to: @text

    def initialize(x, y, text, color = Color::Lime, @focused = false, @padding = PADDING)
      @text = Text.new(
        text: text,
        x: x + @padding,
        y: y + @padding,
        size: 16,
        spacing: 5,
        color: color
      )
    end

    def focus
      @focused = true
    end

    def blur
      @focused = false
    end

    def select
      # TODO: add some kind of select animation
    end

    def draw
      @text.draw
      draw_focused
    end

    def draw_focused
      return unless focused?

      Rectangle.new(
        x: @text.x.to_f32 - @padding,
        y: @text.y.to_f32 - @padding,
        width: @text.width + @padding * 2,
        height: @text.height + @padding * 2,
        color: @text.color,
        filled: false
      ).draw
    end
  end
end
