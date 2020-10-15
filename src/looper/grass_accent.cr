module Looper
  class GrassAccent < Accent
    def initialize(x, y)
      super(x: x, y: y, sprite: Game::Sprite.get(:grass_accents))
      @sprite.frame = Random.rand(@sprite.frames)
    end
  end
end
