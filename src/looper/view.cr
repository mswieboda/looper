module Looper
  class View
    property view_x : Int32 | Float32
    property view_y : Int32 | Float32

    MOVE_SPEED = 300

    def initialize
      @view_x = 0
      @view_y = 0
    end

    def update(frame_time : Float32, player : Player)
      if G.edit_mode?
        movement = MOVE_SPEED * frame_time

        @view_y += movement if Game::Key::W.down?
        @view_x += movement if Game::Key::A.down?
        @view_y -= movement if Game::Key::S.down?
        @view_x -= movement if Game::Key::D.down?
      else
        @view_x = -player.x + G.screen_width / 2_f32
        @view_y = -player.y + G.screen_height / 2_f32
      end
    end
  end
end
