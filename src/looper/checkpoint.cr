module Looper
  class Checkpoint < Obj
    getter? passed

    PASSED_HIT_BOX_COLOR = Color::Lime

    def initialize(x, y, width, height)
      super(
        x: x,
        y: y,
        width: width,
        height: height
      )

      @passed = false
    end

    def draw
      super
    end

    def pass
      @passed = !@passed
      @hit_box_color = passed? ? PASSED_HIT_BOX_COLOR : Obj::HIT_BOX_COLOR
    end

    def reset
      pass if passed?
    end
  end
end
