module Looper
  class Menu
    getter? exit
    getter? shown

    @items : Array(MenuItem)

    def initialize
      @shown = true
      @exit = false

      @items = [
        MenuItem.new(text: "start", x: 100, y: 100, focused: true),
        MenuItem.new(text: "options", x: 100, y: 200),
        MenuItem.new(text: "exit", x: 100, y: 300)
      ]
      @focus_index = 0
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
      item.select

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
