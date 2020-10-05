module Looper
  class Menu
    getter? exit
    getter? shown
    getter? difficulty_shown
    getter difficulty : String

    @items : Array(MenuItem)
    @difficulty_items : Array(MenuItem)

    def initialize
      @shown = true
      @exit = false
      @focus_index = 0
      @difficulty_shown = false
      @difficulty = ""

      @items = [
        MenuItem.new(text: "start"),
        MenuItem.new(text: "exit")
      ]
      @items[@focus_index].focus
      arrange_items

      @difficulty_items = [
        MenuItem.new(text: "noob"),
        MenuItem.new(text: "elite")
      ]
      arrange_difficulty_items
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

    def arrange_difficulty_items
      height = @difficulty_items.map(&.height).sum

      x = Game.screen_width / 2_f32
      y = Game.screen_height / 2_f32 - height / 2_f32

      @difficulty_items.each do |item|
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

      if difficulty_shown?
        @difficulty_items.each(&.draw)
      else
        @items.each(&.draw)
      end
    end

    def focus_next
      focus
    end

    def focus_last
      focus(asc: false)
    end

    def focus(asc = true, wrap = true)
      items = difficulty_shown? ? @difficulty_items : @items

      items[@focus_index].blur

      @focus_index = asc ? @focus_index + 1 : @focus_index - 1

      if wrap
        if @focus_index >= items.size
          @focus_index = 0
        elsif @focus_index < 0
          @focus_index = items.size - 1
        end
      end

      items[@focus_index].focus
    end

    def select_item
      items = difficulty_shown? ? @difficulty_items : @items
      item = items[@focus_index]
      item.blur

      if difficulty_shown?
        @difficulty = item.text
      else
        if item.text == "start"
          @focus_index = 0
          @difficulty_items[@focus_index].focus
          @difficulty_shown = true
        elsif item.text == "exit"
          puts ">>> Menu exit"
          @exit = true
        end
      end
    end

    def show
      @shown = true
      @focus_index = 0
      @items[@focus_index].focus
    end

    def hide
      @shown = false
      @focus_index = 0
      @difficulty_shown = false
      @difficulty = ""
    end
  end
end
