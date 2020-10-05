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

      item.blur

      @difficulty = item.text
      @done = true
    end
  end
end
