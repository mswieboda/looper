module Looper
  class Menu
    getter? exit
    getter? shown

    @items : Array(MenuItem)

    def initialize
      @shown = true
      @exit = false

      @items = [
        MenuItem.new(text: "start", focused: true),
        MenuItem.new(text: "exit")
      ]
      @focus_index = 0

      arrange_items
    end

    def arrange_items
      height = @items.map(&.height).sum

      x = Game.screen_width / 2_f32
      y = Game.screen_height / 2_f32 - height / 2_f32

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
      end
    end

    def draw
      return unless shown?

      @items.each(&.draw)
    end

    def focus_next
      focus
    end

    def focus_last
      focus(asc: false)
    end

    def focus(asc = true, wrap = true)
      @items[@focus_index].blur

      @focus_index = asc ? @focus_index + 1 : @focus_index - 1

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
      item = @items[@focus_index]

      if item.text == "start"
        hide
      elsif item.text == "exit"
        @exit = true
      end
    end

    def show
      @shown = true
    end

    def hide
      @shown = false
    end
  end
end
