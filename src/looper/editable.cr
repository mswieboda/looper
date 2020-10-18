module Looper
  module Editable
    getter? selected

    SELECTED_HIT_BOX_COLOR = Game::Color::Blue
    SELECTED_MOVE_SPEED = 100

    def update(frame_time, view_x, view_y)
      return unless G.edit_mode?

      if Game::Mouse.pressed?(Game::MouseButton::Left)
        if collision?(Game::Vector.new(x: Game::Mouse.x - view_x, y: Game::Mouse.y - view_y))
          @selected = true
        else
          @selected = false
        end
      end

      if selected?
        movement = SELECTED_MOVE_SPEED * frame_time

        x_d = 0_f32
        y_d = 0_f32

        x_d -= movement if Game::Key::Left.down?
        x_d += movement if Game::Key::Right.down?
        y_d -= movement if Game::Key::Up.down?
        y_d += movement if Game::Key::Down.down?

        if !x_d.zero? || !y_d.zero?
          @x += x_d
          @y += y_d

          editable_movement
        end

        if Game::Key::P.pressed?
          puts ">>> #{self.class.name} selected: (#{x}, #{y})"
        end
      end
    end

    def editable_movement
    end
  end
end
