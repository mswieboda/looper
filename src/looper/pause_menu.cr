module Looper
  class PauseMenu < Menu
    ITEMS = %w(resume restart difficulty exit)

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

      if @item == "difficulty"
        @difficulty_menu.show
      else
        @done = true
      end
    end

    def back
      return if @difficulty_menu.shown?
      @item = "resume"
      @done = true
    end

    def hide
      @item = ""
      @difficulty_menu.hide

      @items[@focus_index].blur
      @focus_index = 0
      @items[@focus_index].focus

      super
    end

    def update(frame_time)
      @difficulty_menu.shown? ? @difficulty_menu.update(frame_time) : super
    end

    def draw
      return unless shown?

      if @difficulty_menu.shown?
        @difficulty_menu.draw
      else
        draw_header("paused")
        super
      end
    end
  end
end
