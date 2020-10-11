module Looper
  module Editable
    getter? selected

    SELECTED_HIT_BOX_COLOR = Color::Blue
    SELECTED_MOVE_SPEED = 100

    def update(frame_time, view_x, view_y)
      return unless Game.edit_mode?

      if Mouse.pressed?(MouseButton::Left)
        if collision?(Vector.new(x: Mouse.x - view_x, y: Mouse.y - view_y))
          @selected = true
        else
          @selected = false
        end
      end

      if selected?
        movement = SELECTED_MOVE_SPEED * frame_time

        x_d = 0_f32
        y_d = 0_f32

        x_d -= movement if Key::Left.down?
        x_d += movement if Key::Right.down?
        y_d -= movement if Key::Up.down?
        y_d += movement if Key::Down.down?

        if !x_d.zero? || !y_d.zero?
          @x += x_d
          @y += y_d

          editable_movement
        end

        if Key::P.pressed?
          puts ">>> #{self.class.name} selected: (#{x}, #{y})"
        end
      end
    end

    def editable_movement
    end
  end
end
