module Looper
  class Message
    getter? shown
    getter? done

    # TODO: switch to all Game objs instead of LibRay
    @text_color : LibRay::Color

    MARGIN = 13
    BORDER_SIZE = 3
    PADDING = 13
    MIN_DELAY = 0.5

    @@message = Message.new

    # required to load font after game intialized
    def self.init
      @@message = Message.new
    end

    def self.message
      @@message
    end

    def self.show(message : String)
      @@message.show(message)
    end

    def self.shown?
      message.shown?
    end

    def self.done?
      message.done?
    end

    def initialize
      @shown = false
      @done = false
      @delay = 0_f32

      # TODO: switch to all Game objs instead of LibRay
      @default_font = LibRay.get_font_default
      @text = ""
      @text_font_size = 33
      @text_spacing = 5
      # TODO: switch to all Game objs instead of LibRay
      @text_color = LibRay::WHITE
      @text_measured = LibRay::Vector2.new
    end

    def update(frame_time)
      @done = false

      return unless shown?

      @delay += frame_time

      return if delay?

      if Game::Keys.any_pressed?
        hide
      end
    end

    def draw
      return unless shown?

      draw_background
      draw_border
      draw_message
    end

    def draw_background
      width = G.screen_width - MARGIN * 2
      height = @text_measured.y + PADDING * 2

      x = MARGIN
      y = G.screen_height - MARGIN - BORDER_SIZE - height - BORDER_SIZE

      Game::Rectangle.new(
        x: x,
        y: y,
        width: width,
        height: height + BORDER_SIZE * 2,
        color: Game::Color::Black.alpha(0.6_f32)
      ).draw
    end

    def draw_border
      width = G.screen_width - MARGIN * 2
      height = @text_measured.y + PADDING * 2

      x = MARGIN
      y = G.screen_height - MARGIN - BORDER_SIZE - height - BORDER_SIZE

      BORDER_SIZE.times do |n|
        Game::Rectangle.new(
          x: x + n,
          y: y + n,
          width: width - n * 2,
          height: height + BORDER_SIZE * 2 - n * 2,
          color: Game::Color::White,
          filled: false
        ).draw
      end
    end

    def draw_message(x_start = MARGIN + BORDER_SIZE)
      x = x_start + PADDING
      y = G.screen_height - MARGIN - BORDER_SIZE - PADDING - @text_measured.y

      LibRay.draw_text_ex(
        font: @default_font,
        text: @text,
        position: LibRay::Vector2.new(
          x: x,
          y: y
        ),
        font_size: @text_font_size,
        spacing: @text_spacing,
        tint: @text_color
      )

      return if delay?

      x = x_start + G.screen_width - x_start - MARGIN - BORDER_SIZE - PADDING
      y = G.screen_height - MARGIN - BORDER_SIZE - PADDING

      # temp message done icon

      # outer
      rect = Game::Square.new(size: 30, color: Game::Color::White, filled: false)
      rect.x = x - rect.width
      rect.y = y - rect.height
      rect.draw

      # inner
      rect = Game::Square.new(size: 10, color: Game::Color::White)
      rect.x = x - rect.width - 10
      rect.y = y - rect.height - 10
      rect.draw
    end

    def update_text_measured
      @text_measured = LibRay.measure_text_ex(
        font: @default_font,
        text: @text,
        font_size: @text_font_size,
        spacing: @text_spacing
      )
    end

    def show(message : String)
      @text = message
      @text_measured = LibRay.measure_text_ex(
        font: @default_font,
        text: @text,
        font_size: @text_font_size,
        spacing: @text_spacing
      )
      @shown = true
    end

    def hide
      @shown = false
      @done = true
      @text = ""
      @delay = 0_f32
      update_text_measured
    end

    def delay?
      @delay < MIN_DELAY
    end
  end
end
