module Looper
  class Menu
    getter? exit
    getter? shown
    getter? difficulty_shown
    getter difficulty : String
    property? done

    @items : Array(MenuItem)
    @difficulty_items : Array(MenuItem)

    def initialize
      @shown = true
      @exit = false
      @focus_index = 0
      @focus_difficulty_index = 0
      @difficulty_shown = false
      @difficulty = ""
      @done = false

      @items = [
        MenuItem.new(text: "start"),
        MenuItem.new(text: "exit")
      ]

      @difficulty_items = [
        MenuItem.new(text: "noob"),
        MenuItem.new(text: "elite")
      ]

      reset_items
    end

    def items
      difficulty_shown? ? @difficulty_items : @items
    end

    def focus_index
      difficulty_shown? ? @focus_index : @focus_difficulty_index
    end

    def focus_index_first
      if difficulty_shown?
        @focus_index = 0
      else
        @focus_difficulty_index = 0
      end
    end

    def focus_index_last
      index = items.size - 1

      if difficulty_shown?
        @focus_index = index
      else
        @focus_difficulty_index = index
      end
    end

    def focus_index_add(value : Int8)
      if difficulty_shown?
        @focus_index += value
      else
        @focus_difficulty_index += value
      end
    end

    def focused_item
      items[focus_index]
    end

    def items_width
      items.map(&.width).max
    end

    def items_height
      items.map(&.height).sum
    end

    def arrange_items
      x = Game.screen_width / 2_f32
      y = Game.screen_height / 2_f32 - items_height / 2_f32

      items.each do |item|
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

      draw_background

      items.each(&.draw)
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

    def focus_next
      focus
    end

    def focus_last
      focus(asc: false)
    end

    def focus(asc = true, wrap = true)
      focused_item.blur

      focus_index_add(asc ? 1_i8 : -1_i8)

      if wrap
        if focus_index >= items.size
          focus_index_first
        elsif focus_index < 0
          focus_index_last
        end
      end

      focused_item.focus
    end

    def select_item
      item = focused_item
      item.blur

      if difficulty_shown?
        @difficulty = item.text
        @done = true
      else
        if item.text == "start"
          @difficulty_shown = true
          reset_items
        elsif item.text == "exit"
          puts ">>> Menu exit"
          @exit = true
        end
      end
    end

    def show
      @shown = true
    end

    def reset_items
      focused_item.focus
      arrange_items
    end

    def hide
      @shown = false
      @difficulty_shown = false

      reset_items
    end
  end
end
