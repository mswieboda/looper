module Looper
  class MenuItem
    PADDING = 25

    getter? focused

    @padding : Int32

    delegate :text, to: @text

    def initialize(x = 0, y = 0, text = "", color = Color::Lime, @focused = false, @padding = PADDING)
      @text = Text.new(
        text: text,
        x: x + @padding,
        y: y + @padding,
        size: 25,
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

    def x
      @text.x.to_f32 - @padding
    end

    def x=(value : Int32 | Float32)
      @text.x = value + @padding
    end

    def y
      @text.y.to_f32 - @padding
    end

    def y=(value : Int32 | Float32)
      @text.y = value + @padding
    end

    def width
      @text.width + @padding * 2
    end

    def height
      @text.height + @padding * 2
    end

    def draw
      @text.draw
      draw_focused
    end

    def draw_focused
      return unless focused?

      Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height,
        color: @text.color,
        filled: false
      ).draw
    end
  end
end
