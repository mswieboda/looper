module Looper
  abstract class Menu
    getter? shown
    property? done

    @items : Array(MenuItem)

    def initialize(items : Array(String))
      @shown = false
      @exit = false
      @focus_index = 0
      @done = false

      @items = items.map { |item| MenuItem.new(text: item) }

      arrange_items
    end

    def items_width
      @items.map(&.width).max
    end

    def items_height
      @items.map(&.height).sum
    end

    def arrange_items
      x = Game.screen_width / 2_f32
      y = Game.screen_height / 2_f32 - items_height / 2_f32

      @items.each do |item|
        item.x = x - item.width / 2_f32
        item.y = y

        y += item.height
      end
    end

    def update(frame_time)
      return unless shown?

      if Keys.pressed?([Key::Down, Key::S])
        focus_next
      elsif Keys.pressed?([Key::Up, Key::W])
        focus_last
      elsif Keys.pressed?([Key::Enter, Key::Space, Key::LShift, Key::RShift])
        select_item
      elsif Keys.pressed?([Key::Escape, Key::Backspace])
        back
      end
    end

    def draw
      return unless shown?

      draw_background

      @items.each(&.draw)
    end

    def draw_background
      padding = 50

      x = Game.screen_width / 2_f32
      y = Game.screen_height / 2_f32 - items_height / 2_f32

      Rectangle.new(
        x: x - items_width / 2_f32 - padding,
        y: y - padding,
        width: items_width + padding * 2,
        height: items_height + padding * 2,
        color: Color::Black,
      ).draw
    end

    def back
      # to be overriden
    end

    def focus_next
      focus
    end

    def focus_last
      focus(asc: false)
    end

    def focus(asc = true, wrap = true)
      @items[@focus_index].blur

      @focus_index += asc ? 1 : -1

      if wrap
        if @focus_index >= @items.size
          @focus_index = 0
        elsif @focus_index < 0
          @focus_index = @items.size - 1
        end
      end

      @items[@focus_index].focus
    end

    def select_item
      # to be overriden
    end

    def show
      @shown = true
      @items[@focus_index].focus
    end

    def hide
      @shown = false
      @done = false

      @items[@focus_index].blur
    end
  end
end
