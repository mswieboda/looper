require "./menu"

module Looper
  class DifficultyMenu < Menu
    getter difficulty : String

    def initialize
      super(%w(noob elite))

      @difficulty = ""
    end

    def select_item
      item = @items[@focus_index]

      @difficulty = item.text
      @done = true
    end

    def back
      hide
    end

    def draw
      return unless shown?

      draw_header("difficulty")
      super
    end
  end
end
