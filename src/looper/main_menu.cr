module Looper
  class MainMenu < Menu
    getter? exit

    delegate :difficulty, to: @difficulty_menu

    @difficulty_menu : DifficultyMenu

    def initialize
      super(%w(start exit))

      @difficulty_menu = DifficultyMenu.new
    end

    def done?
      @difficulty_menu.shown? && @difficulty_menu.done?
    end

    def select_item
      item = @items[@focus_index]

      item.blur

      if @difficulty_menu.shown? && @difficulty_menu.done?
        @done = true
      else
        if item.text == "start"
          @difficulty_menu.show
        elsif item.text == "exit"
          @exit = true
        end
      end
    end

    def hide
      @difficulty_menu.hide

      super
    end

    def update(frame_time)
      @difficulty_menu.shown? ? @difficulty_menu.update(frame_time) : super
    end

    def draw
      @difficulty_menu.shown? ? @difficulty_menu.draw : super
    end
  end
end
