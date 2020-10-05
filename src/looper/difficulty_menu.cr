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
  end
end
