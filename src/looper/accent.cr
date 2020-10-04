require "./tile"

module Looper
  class Accent
    COLOR = Color::Green
    SIZE = 8

    property x : Int32 | Float32
    property y : Int32 | Float32

    delegate :width, :height, to: @sprite

    enum Design
      Road
      Grass
      River

      def frames
        case self
        when .road?
          0..31
        when .grass?
          32..63
        when .river?
          64..80
        else
          0..0 # not sure how to make an empty range
        end
      end

      def rand_frame
        Random.rand(frames)
      end
    end

    def initialize(@x, @y, @design = Design::Grass)
      @sprite = Sprite.get(:accents)
      @sprite.frame = @design.rand_frame
    end

    def draw
      @sprite.draw(x: x, y: y)
    end
  end
end
