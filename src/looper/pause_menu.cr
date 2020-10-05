module Looper
  class PauseMenu < Menu
    ITEMS = %w(resume restart change exit)

    delegate :difficulty, to: @difficulty_menu

    @item : String
    @difficulty_menu : DifficultyMenu

    def initialize
      super(ITEMS)

      @item = ""
      @difficulty_menu = DifficultyMenu.new
    end

    {% for item in ITEMS %}
      def {{item.id}}?
        done? && @item == {{item}}
      end
    {% end %}

    def done?
      @difficulty_menu.shown? ? @difficulty_menu.done? : super
    end

    def select_item
      item = @items[@focus_index]

      @item = item.text

      if @item == "change"
        @difficulty_menu.show
      else
        @done = true
      end
    end

    def back
      return if @difficulty_menu.shown?
      hide
    end

    def hide
      @item = ""
      @difficulty_menu.hide
      @focus_index = 0

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
